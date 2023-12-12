struct Data(Vec<Option<Node<T>>>);

impl<T> Data<T> {
    fn insert(node: Node<T>) -> usize {
        match self.empty_slot_index {
            Some(index) => {
                self.0[index] = Some(node);
                index
            },
            None => {
                let index = self.0.len();
                self.0.push(node);
                index
            }
        }
    }
    fn take(index: usize) -> T {
        return self.0[index].take()
    }
    fn peek(index: usize) -> &T {
        return &self.0[index]
    }
    fn empty_slot_index() -> Option<usize> {
        return self.0.iter().position(|x| x.is_none())
    }
}

pub struct LinkedList {
    data: Data<T>,
    front: Option<usize>,
    back: Option<usize>,
}

struct Node {
    element: T,
    next: Option<usize>,
    prev: Option<usize>,
}

impl<T> LinkedList<T> {
    pub fn new() -> Self {
        unimplemented!()
    }
    pub fn len(&self) -> usize {
        unimplemented!()
    }
    /// Return a cursor positioned on the front element
    pub fn cursor_front(&mut self) -> Cursor<T> {
        Cursot {curr: self.front, list: self}
    }
}


pub struct Cursor<'a, T> {
    curr: Option<usize>,
    list: &'a mut LinkedList,
}

impl<'a, T> Cursor<'a, T> {
    pub fn insert_before(&mut self, element: T) {
        let node = Node{
            element,
            next: self.curr.map(|x| x.next),
            prev: self.curr,
        };
        let index = self.list.data.insert(node);
        
        self.curr.next = Some(index);
        self.list.front = Some(index);
    }
}


pub struct Iter<'a, T> {
    curr: Option<usize>, 
    list: &'a mut LinkedList,
}

impl<'a, T> Iterator for Iter<'a, T> {
    type Item = &'a T;

    fn next(&mut self) -> Option<&'a T> {
        self.curr.map(|x| &list.data.peek().element)
    }
}