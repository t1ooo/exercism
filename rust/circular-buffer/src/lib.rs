use std::collections::VecDeque;

pub struct CircularBuffer<T> {
    data: VecDeque<T>,
    cap: usize,
}

#[derive(Debug, PartialEq)]
pub enum Error {
    EmptyBuffer,
    FullBuffer,
}

impl<T> CircularBuffer<T> {
    pub fn new(capacity: usize) -> Self {
        Self {
            data: VecDeque::with_capacity(capacity),
            cap: capacity,
        }
    }

    pub fn write(&mut self, element: T) -> Result<(), Error> {
        if self.is_full() {
            Err(Error::FullBuffer)
        } else {
            self.data.push_back(element);
            Ok(())
        }
    }

    pub fn read(&mut self) -> Result<T, Error> {
        match self.data.pop_front() {
            Some(element) => Ok(element),
            None => Err(Error::EmptyBuffer),
        }
    }

    pub fn clear(&mut self) {
        self.data.clear();
    }

    pub fn overwrite(&mut self, element: T) {
        if self.is_full() {
            let _ = self.read();
        }
        self.data.push_back(element);
    }

    fn is_full(&self) -> bool {
        self.cap <= self.data.len()
    }
}
