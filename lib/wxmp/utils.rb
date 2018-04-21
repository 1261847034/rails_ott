module Wxmp
  module Utils
    module PKCS7Padding
      BLOCK_SIZE = 32
      class << self
        def add_padding(data)
          padding_amount = BLOCK_SIZE - (data.bytesize % BLOCK_SIZE)
          padding_amount = BLOCK_SIZE if padding_amount == 0

          data.concat(padding_amount.chr * padding_amount)
        end

        def remove_padding(data)
          padding_amount = data[data.length - 1].ord
          padding_amount = 0 if padding_amount < 1 || padding_amount > BLOCK_SIZE

          data.slice!(data.length - padding_amount, padding_amount)
        end
      end
    end

    module NetworkOrder
      class << self
        # little-endian int to big-endian bytes
        def int_to_bytes(number)
          Array(number).pack('N')
        end

        def bytes_to_int(bytes)
          bytes.unpack('N').first
        end

        def int_to_bytes_cus(number)
          byte0 = number & 0xff
          byte1 = number >> 8  & 0xff
          byte2 = number >> 16 & 0xff
          byte3 = number >> 24 & 0xff

          byte0 << 24 | byte1 << 16 | byte2 << 8 | byte3
        end

        def bytes_to_int_cus(bytes)
          byte0 = bytes[0] & 0xff
          byte1 = bytes[1] & 0xff
          byte2 = bytes[2] & 0xff
          byte3 = bytes[3] & 0xff

          byte0 << 24 | byte1 << 16 | byte2 << 8 | byte3
        end
      end
    end
  end
end
