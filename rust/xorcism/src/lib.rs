use std::borrow::Borrow;
use std::io::{Read, Result as IoResult, Write};
use std::iter::Cycle;

/// A munger which XORs a key with some data
#[derive(Clone)]
pub struct Xorcism {
    key: Cycle<std::vec::IntoIter<u8>>,
}

/// For composability, it is important that `munge` returns an iterator compatible with its input.
///
/// However, `impl Trait` syntax can specify only a single non-auto trait.
/// Therefore, we define this output trait with generic implementations on all compatible types,
/// and return that instead.
pub trait MungeOutput: Iterator<Item = u8> + ExactSizeIterator {}
impl<T> MungeOutput for T where T: Iterator<Item = u8> + ExactSizeIterator {}

impl Xorcism {
    /// Create a new Xorcism munger from a key
    ///
    /// Should accept anything which has a cheap conversion to a byte slice.
    pub fn new<Key: AsRef<[u8]> + ?Sized>(key: &Key) -> Self {
        Self {
            key: key.as_ref().to_vec().into_iter().cycle(),
        }
    }

    /// XOR each byte of the input buffer with a byte from the key.
    ///
    /// Note that this is stateful: repeated calls are likely to produce different results,
    /// even with identical inputs.
    pub fn munge_in_place(&mut self, data: &mut [u8]) {
        data.iter_mut().for_each(|x| {
            *x ^= self.key.next().unwrap();
        })
    }

    /// XOR each byte of the data with a byte from the key.
    ///
    /// Note that this is stateful: repeated calls are likely to produce different results,
    /// even with identical inputs.
    ///
    /// Should accept anything which has a cheap conversion to a byte iterator.
    /// Shouldn't matter whether the byte iterator's values are owned or borrowed.
    pub fn munge<'s, 'a, I, Data>(&'s mut self, data: Data) -> impl MungeOutput + 's
    where
        I: Borrow<u8>,
        Data: 'a + IntoIterator<Item = I>,
        <Data as IntoIterator>::IntoIter: ExactSizeIterator,
        'a: 's,
    {
        data.into_iter()
            .map(move |x| x.borrow() ^ self.key.next().unwrap())
    }

    pub fn reader<R: Read>(self, reader: R) -> impl Read {
        XorcismReader { reader, s: self }
    }

    pub fn writer<W: Write>(self, writer: W) -> impl Write {
        XorcismWriter { writer, s: self }
    }
}

pub struct XorcismReader<R: Read> {
    reader: R,
    s: Xorcism,
}

impl<R: Read> Read for XorcismReader<R> {
    fn read(&mut self, buf: &mut [u8]) -> IoResult<usize> {
        self.reader.read(buf).map(|len| {
            self.s.munge_in_place(buf);
            len
        })
    }
}

pub struct XorcismWriter<W: Write> {
    writer: W,
    s: Xorcism,
}

impl<W: Write> Write for XorcismWriter<W> {
    fn write(&mut self, buf: &[u8]) -> IoResult<usize> {
        let data = self.s.munge(buf).collect::<Vec<_>>();
        self.writer.write(&data)
    }

    fn flush(&mut self) -> std::io::Result<()> {
        self.writer.flush()
    }
}
