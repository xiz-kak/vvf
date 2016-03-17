module Encryptor
  extend ActiveSupport::Concern

  def encrypt(val)
    return if val.blank?
    enc = encryptor
    enc.encrypt
    encrypted = enc.update(val) + enc.final
    Base64.encode64(encrypted).encode('utf-8')
  end

  def decrypt(val)
    return if val.blank?
    dec = encryptor
    dec.decrypt
    decoded = Base64.decode64 val.encode('ascii-8bit')
    dec.update(decoded) + dec.final
  end

  private

  def encryptor
    enc = OpenSSL::Cipher::DES.new('ECB')
    enc.pkcs5_keyivgen(ENV['ENCRYPTOR_KEY'])
    enc
  end
end
