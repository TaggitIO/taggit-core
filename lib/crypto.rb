module Crypto
  class Cipher
    # Public: Initialize a new Cipher object.
    def initialize
      @cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    end

    # Public: AES encrypts a String.
    #
    # data - A String to encrypt.
    #
    # Examples
    #   cipher.encrypt('some text')
    #   # => "BTOcdYJbZH/09OesCFC6yA==a43de3b77b45d243"
    #
    # Returns a Base 64 encoded string of the encrypted data with the initial
    # vector appended.
    def encrypt(data)
      @cipher.encrypt
      @cipher.key = ENV['TAGGIT_ENCRYPT_KEY']

      iv = SecureRandom.hex(8)
      @cipher.iv = iv

      data = @cipher.update(data) + @cipher.final
      data = Base64.strict_encode64(data)
      "#{data}#{iv}"
    end

    # Public: Decrypts an AES encrypted String.
    #
    # data - A String to decrypt.
    #
    # Examples
    #   cipher.decrypt("BTOcdYJbZH/09OesCFC6yA==a43de3b77b45d243")
    #   # => "some text"
    #
    # Returns the decrypted value of the String.
    def decrypt(data)
      iv   = data[-16..-1]
      data = data[0..-17]

      data = Base64.strict_decode64(data)

      @cipher.decrypt
      @cipher.key = ENV['TAGGIT_ENCRYPT_KEY']

      @cipher.iv = iv
      @cipher.update(data) + @cipher.final
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
      cipher = Cipher.new#(:encrypt)
      cipher.encrypt(data)
    end

    def decrypt(data)
      cipher = Cipher.new#(:decrypt)
      cipher.decrypt(data)
    end
  end
end
