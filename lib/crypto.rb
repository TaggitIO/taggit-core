module Crypto
  class Cipher
    def initialize(mode)
      @cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      @cipher.send(mode)

      @cipher.key = ENV['TAGGIT_ENCRYPT_KEY']
    end

    def encrypt(data)
      @cipher.iv = iv

      data = @cipher.update(data) + @cipher.final
      data = Base64.strict_encode64(data)
      "#{data}#{iv}"
    end

    def decrypt(data)
      iv   = data[-16..-1]
      data = data[0..-17]

      data = Base64.strict_decode64(data)

      @cipher.iv = iv
      @cipher.update(data) + @cipher.final
    end

    private

    def iv
      @_iv ||= SecureRandom.hex(8)
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def decrypt(data)
    self.class.decrypt(data)
  end

  module ClassMethods
    def encrypt(data)
      cipher = Cipher.new(:encrypt)
      cipher.encrypt(data)
    end

    def decrypt(data)
      cipher = Cipher.new(:decrypt)
      cipher.decrypt(data)
    end
  end
end
