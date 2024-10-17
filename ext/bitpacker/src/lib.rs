use bitpacking::BitPacker;
use paste::paste;

use magnus::{function, method, Error, Module, Object, RModule, RString, Ruby};

macro_rules! Wrap {
    ( $x:ident ) => {
        paste! {
            #[magnus::wrap(class = "BitPacker::"$x )]
            struct $x(bitpacking::$x);
        }

        impl $x {
            const BLOCK_LEN: usize = bitpacking::$x::BLOCK_LEN;
            fn new() -> Self {
                Self(bitpacking::$x::new())
            }
            fn block_len(&self) -> usize {
                bitpacking::$x::BLOCK_LEN
            }
            fn num_bits(&self, decompressed: Vec<u32>) -> u8 {
                self.0.num_bits(&decompressed)
            }

            // TODO: _sorted and _strictly_sorted methods

            fn compress(
                ruby: &Ruby,
                rb_self: &Self,
                decompressed: Vec<u32>,
                num_bits: u8,
            ) -> RString {
                let mut compressed = vec![0u8; 4 * Self::BLOCK_LEN];
                let len = rb_self
                    .0
                    .compress(&decompressed, compressed.as_mut_slice(), num_bits);
                compressed.truncate(len);
                ruby.str_from_slice(compressed.as_slice())
            }

            fn decompress(&self, compressed: RString, num_bits: u8) -> (Vec<u32>, usize) {
                let mut decompressed = vec![0u32; Self::BLOCK_LEN];
                let len = unsafe {
                    self.0.decompress(
                        &compressed.as_slice(),
                        decompressed.as_mut_slice(),
                        num_bits,
                    )
                };
                (decompressed, len)
            }

            fn register(ruby: &Ruby, module: &RModule) -> Result<(), Error> {
                let class = module.define_class(stringify!($x), ruby.class_object())?;
                class.define_singleton_method("new", function!($x::new, 0))?;
                class.const_set("BLOCK_LEN", Self::BLOCK_LEN)?;
                class.define_method("num_bits", method!($x::num_bits, 1))?;
                class.define_method("compress", method!($x::compress, 2))?;
                class.define_method("decompress", method!($x::decompress, 2))?;
                class.define_method("block_len", method!($x::block_len, 0))?;
                Ok(())
            }
        }
    };
}

Wrap!(BitPacker1x);
Wrap!(BitPacker4x);
Wrap!(BitPacker8x);

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let module = ruby.define_module("BitPacker")?;

    BitPacker1x::register(ruby, &module)?;
    BitPacker4x::register(ruby, &module)?;
    BitPacker8x::register(ruby, &module)?;
    Ok(())
}
