module Crypto
  class Cipher
    # Public: AES encrypts a String.
    #
    # data - A String to encrypt.
    #
    # Examples
    #   Crypto::Cipher.encrypt('some text')
    #   # => "BTOcdYJbZH/09OesCFC6yA==a43de3b77b45d243"
    #
    # Returns a Base 64 encoded string of the encrypted data with the initial
    # vector appended.
    def self.encrypt(data)
      cipher.encrypt
      iv = SecureRandom.hex(8)

      cipher.key = ENV['TAGGIT_ENCRYPT_KEY']
      cipher.iv  = iv

      data = cipher.update(data) + cipher.final
      data = Base64.strict_encode64(data)
      "#{data}#{iv}"
    end

    # Public: Decrypts an AES encrypted String.
    #
    # data - A String to decrypt.
    #
    # Examples
    #   Crypto::Cipher.decrypt("BTOcdYJbZH/09OesCFC6yA==a43de3b77b45d243")
    #   # => "some text"
    #
    # Returns the decrypted value of the String.
    def self.decrypt(data)
      iv   = data[-16..-1]
      data = data[0..-17]

      data = Base64.strict_decode64(data)

      cipher.decrypt

      cipher.key = ENV['TAGGIT_ENCRYPT_KEY']
      cipher.iv  = iv

      cipher.update(data) + cipher.final
    end

    private

    # Private: Creates and memoizes an AES cipher.
    def self.cipher
      @_cipher ||= OpenSSL::Cipher::AES.new(256, :CBC)
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
      Cipher.encrypt(data)
    end

    def decrypt(data)
      Cipher.decrypt(data)
    end
  end
end
