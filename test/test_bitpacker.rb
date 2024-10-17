# frozen_string_literal: true

require "test_helper"

class TestBitpacker < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BitPacker::VERSION
  end
end

class TestBitpacker4x < Minitest::Test
  def test_blocklen_constant
    assert_equal 128, ::BitPacker::BitPacker4x::BLOCK_LEN
  end

  def test_blocklen_attribute
    packer = ::BitPacker::BitPacker4x.new

    assert_equal 128, packer.block_len
  end

  def test_num_bits
    packer = ::BitPacker::BitPacker4x.new
    numbers = [0] * ::BitPacker::BitPacker4x::BLOCK_LEN

    assert_equal 0, packer.num_bits(numbers)

    numbers[0] = 1

    assert_equal 1, packer.num_bits(numbers)

    numbers[1] = 255

    assert_equal 8, packer.num_bits(numbers)
  end

  def test_compress
    packer = ::BitPacker::BitPacker4x.new

    numbers = [63] * ::BitPacker::BitPacker4x::BLOCK_LEN

    num_bits = packer.num_bits(numbers)
    compressed = packer.compress(numbers, num_bits)

    assert_equal 96, compressed.length
    assert_equal "\xFF".b * 96, compressed
  end

  def test_decompress
    packer = ::BitPacker::BitPacker4x.new

    10.times do
      numbers = [rand(2**32)] * packer.block_len
      num_bits = packer.num_bits(numbers)
      compressed = packer.compress(numbers, num_bits)
      decompressed, = packer.decompress(compressed, num_bits)

      assert_equal numbers, decompressed
    end
  end
end
