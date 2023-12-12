use std::marker::PhantomData;
use std::ptr::NonNull;

// this module adds some functionality based on the required implementations
// here like: `LinkedList::pop_back` or `Clone for LinkedList<T>`
// You are free to use anything in it, but it's mainly for the test framework.
mod pre_implemented;

// ------------------------------------------------

type Link<T> = Option<NonNull<Node<T>>>;

#[derive(Debug)]
struct Node<T> {
    element: T,
    next: Link<T>,
    prev: Link<T>,
}

impl<T> Node<T> {
    fn new(element: T) -> Self {
        Self {
            element,
            next: None,
            prev: None,
        }
    }
}

// ------------------------------------------------

#[derive(Debug)]
pub struct LinkedList<T> {
    front: Link<T>,
    back: Link<T>,
    len: usize,
}

impl<T> LinkedList<T> {
    pub fn new() -> Self {
        Self {
            front: None,
            back: None,
            len: 0,
        }
    }

    pub fn len(&self) -> usize {
        self.len
    }

    /// Return a cursor positioned on the front element
    pub fn cursor_front(&mut self) -> Cursor<'_, T> {
        Cursor {
            curr: self.front,
            list: self,
        }
    }

    /// Return a cursor positioned on the back element
    pub fn cursor_back(&mut self) -> Cursor<'_, T> {
        Cursor {
            curr: self.back,
            list: self,
        }
    }

    /// Return an iterator that moves from front to back
    pub fn iter(&self) -> Iter<'_, T> {
        Iter {
            curr: self.front,
            phantom: PhantomData,
        }
    }
}

impl<T> Drop for LinkedList<T> {
    fn drop(&mut self) {
        let mut node = self.front;
        while let Some(curr) = node {
            let prev = prev_link(curr);
            unsafe { drop_nonnull(curr) };
            node = prev;
        }
    }
}

impl<T> Default for LinkedList<T> {
    fn default() -> Self {
        Self::new()
    }
}

unsafe impl<T: Sync> Sync for LinkedList<T> {}
unsafe impl<T: Send> Send for LinkedList<T> {}

// ------------------------------------------------

#[derive(Debug)]
pub struct Cursor<'a, T> {
    curr: Link<T>,
    list: &'a mut LinkedList<T>,
}

// the cursor is expected to act as if it is at the position of an element
// and it also has to work with and be able to insert into an empty list.
impl<T> Cursor<'_, T> {
    /// Take a mutable reference to the current element
    pub fn peek_mut(&mut self) -> Option<&mut T> {
        match self.curr.as_mut() {
            Some(curr) => Some(unsafe { &mut curr.as_mut().element }),
            None => None,
        }
    }

    /// Move one position forward (towards the back) and
    /// return a reference to the new position
    pub fn next(&mut self) -> Option<&mut T> {
        match self.curr {
            Some(curr) => {
                self.curr = prev_link(curr);
                self.peek_mut()
            }
            None => None,
        }
    }

    /// Move one position backward (towards the front) and
    /// return a reference to the new position
    pub fn prev(&mut self) -> Option<&mut T> {
        match self.curr {
            Some(curr) => {
                self.curr = next_link(curr);
                self.peek_mut()
            }
            None => None,
        }
    }

    /// Remove and return the element at the current position and move the cursor
    /// to the neighboring element that's closest to the back. This can be
    /// either the next or previous position.
    pub fn take(&mut self) -> Option<T> {
        match self.curr {
            Some(curr) => {
                let Node {
                    element,
                    prev,
                    next,
                } = unsafe { take_nonnull(curr) };

                connect_links(prev, next);

                self.curr = if prev.is_some() { prev } else { next };

                if next.is_none() {
                    self.list.front = prev;
                }
                if prev.is_none() {
                    self.list.back = next;
                }
                self.list.len -= 1;

                Some(element)
            }
            None => None,
        }
    }

    // insert to back
    pub fn insert_after(&mut self, element: T) {
        let next = self.curr;
        let prev = self.curr.map(prev_link).flatten();
        self.insert(element, prev, next);
    }

    // insert to front
    pub fn insert_before(&mut self, element: T) {
        let prev = self.curr;
        let next = self.curr.map(next_link).flatten();
        self.insert(element, prev, next);
    }

    fn insert(&mut self, element: T, prev: Link<T>, next: Link<T>) {
        let link = new_nonnull(Node::new(element));

        connect_links(prev, Some(link));
        connect_links(Some(link), next);

        if next_link(link).is_none() {
            self.list.front = Some(link);
        }
        if prev_link(link).is_none() {
            self.list.back = Some(link);
        }
        self.list.len += 1;
    }
}

// ------------------------------------------------

pub struct Iter<'a, T> {
    curr: Link<T>,
    phantom: PhantomData<&'a T>,
}

impl<'a, T> Iterator for Iter<'a, T> {
    type Item = &'a T;

    fn next(&mut self) -> Option<&'a T> {
        match self.curr {
            Some(curr) => {
                let node = unsafe { &*curr.as_ptr() };
                self.curr = node.prev;
                Some(&node.element)
            }
            None => None,
        }
    }
}

// ------------------------------------------------

fn prev_link<T>(node: NonNull<Node<T>>) -> Link<T> {
    unsafe { node.as_ref().prev }
}

fn next_link<T>(node: NonNull<Node<T>>) -> Link<T> {
    unsafe { node.as_ref().next }
}

fn connect_links<T>(prev: Link<T>, next: Link<T>) {
    if prev.is_some() && next.is_some() && prev == next {
        panic!("pointer equals");
    }

    if let Some(mut node) = prev {
        unsafe {
            node.as_mut().next = next;
        }
    }

    if let Some(mut node) = next {
        unsafe {
            node.as_mut().prev = prev;
        }
    }
}

// ------------------------------------------------

fn new_nonnull<T>(v: T) -> NonNull<T> {
    Box::leak(Box::new(v)).into()
}

unsafe fn take_nonnull<T>(v: NonNull<T>) -> T {
    *Box::from_raw(v.as_ptr())
}

unsafe fn drop_nonnull<T>(v: NonNull<T>) {
    take_nonnull(v);
}
