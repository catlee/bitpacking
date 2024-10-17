# frozen_string_literal: true

require "test_helper"

class TestBitPacking < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BitPacking::VERSION
  end
end

class TestBitPacking < Minitest::Test
  def test_blocklen_constant
    assert_equal 128, ::BitPacking::BitPacker4x::BLOCK_LEN
  end

  def test_blocklen_attribute
    packer = ::BitPacking::BitPacker4x.new

    assert_equal 128, packer.block_len
  end

  def test_num_bits
    packer = ::BitPacking::BitPacker4x.new
    numbers = [0] * ::BitPacking::BitPacker4x::BLOCK_LEN

    assert_equal 0, packer.num_bits(numbers)

    numbers[0] = 1

    assert_equal 1, packer.num_bits(numbers)

    numbers[1] = 255

    assert_equal 8, packer.num_bits(numbers)
  end

  def test_compress
    packer = ::BitPacking::BitPacker4x.new

    numbers = [63] * ::BitPacking::BitPacker4x::BLOCK_LEN

    num_bits = packer.num_bits(numbers)
    compressed = packer.compress(numbers, num_bits)

    assert_equal 96, compressed.length
    assert_equal "\xFF".b * 96, compressed
  end

  def test_decompress
    packer = ::BitPacking::BitPacker4x.new

    10.times do
      numbers = [rand(2**32)] * packer.block_len
      num_bits = packer.num_bits(numbers)
      compressed = packer.compress(numbers, num_bits)
      decompressed, = packer.decompress(compressed, num_bits)

      assert_equal numbers, decompressed
    end
  end
end
