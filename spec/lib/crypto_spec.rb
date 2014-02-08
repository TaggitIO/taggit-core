require 'spec_helper'

describe Crypto::Cipher do
  let(:encrypted) do
    cipher = Crypto::Cipher.new(:encrypt)
    cipher.encrypt('foobar')
  end

  describe '#encrypt' do
    it 'should AES encrypt a string' do
      expect(encrypted).to_not eq 'foobar'
    end
  end

  describe '#decrypt' do
    it 'should decrypt an AES-encrypted string' do
      cipher = Crypto::Cipher.new(:decrypt)
      data = cipher.decrypt(encrypted)

      expect(data).to eq 'foobar'
    end
  end
end
