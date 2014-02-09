require 'spec_helper'

describe Crypto::Cipher do
  let(:encrypted) { Crypto::Cipher.encrypt('foobar') }

  describe '#encrypt' do
    it 'should AES encrypt a string' do
      expect(encrypted).to_not eq 'foobar'
    end
  end

  describe '#decrypt' do
    it 'should decrypt an AES-encrypted string' do
      data = Crypto::Cipher.decrypt(encrypted)

      expect(data).to eq 'foobar'
    end
  end
end
