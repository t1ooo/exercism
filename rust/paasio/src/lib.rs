use std::io::{Read, Result, Write};

macro_rules! stats {
    ($name:ident) => {
        pub struct $name<T> {
            wrapper: T,
            count: usize,
            bytes_through: usize,
        }

        impl<T> $name<T> {
            pub fn new(wrapper: T) -> Self {
                Self {
                    wrapper,
                    count: 0,
                    bytes_through: 0,
                }
            }

            pub fn get_ref(&self) -> &T {
                &self.wrapper
            }

            pub fn bytes_through(&self) -> usize {
                self.bytes_through
            }
        }
    };
}

// ----------------------------------------------

stats!(ReadStats);

impl<T> ReadStats<T> {
    pub fn reads(&self) -> usize {
        self.count
    }
}

impl<T: Read> Read for ReadStats<T> {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        self.wrapper.read(buf).map(|len| {
            self.count += 1;
            self.bytes_through += len;
            len
        })
    }
}

// ----------------------------------------------

stats!(WriteStats);

impl<T> WriteStats<T> {
    pub fn writes(&self) -> usize {
        self.count
    }
}
impl<T: Write> Write for WriteStats<T> {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        self.wrapper.write(buf).map(|len| {
            self.count += 1;
            self.bytes_through += len;
            len
        })
    }

    fn flush(&mut self) -> Result<()> {
        self.wrapper.flush()
    }
}
