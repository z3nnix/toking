=begin
toking - шифроватор от бога

версия: 1.0 indev
создал и придумал: @Setscript
=end

require "securerandom"
require "openssl"

class Token
  attr_accessor :data

  def user(data)
    token = SecureRandom.random_number(2**data)
    return token
  end

  def ono(data)
    token = SecureRandom.random_number(16**data)
    return token
  end

  def mono(data)
    token = SecureRandom.random_number(64**data)
    return token
  end

  def bot(data)
    token = SecureRandom.random_number(124**data)
    return token
  end
end

class Send
  attr_accessor :data, :data1

  def token(data1)
    data = data1

    File.open("tmp.bin", "w") do |file|
      file.write(data)
    end
  end
end

class Check
  attr_accessor :data, :data1, :tmp

  def token(data)
    data1 = File.read("tmp.bin")
    tmp = data1.to_i

    if data == tmp
      return true
    else
      return false
    end
  end
end

class Protect
  attr_accessor :text, :password

  def encode(text, password)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = OpenSSL::Digest::SHA256.new(password.to_s).digest
    iv = cipher.random_iv

    encrypted = cipher.update(text) + cipher.final
    encrypted = iv + encrypted

    encrypted.unpack('H*')[0]
  end

def decode(encrypted, password)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.decrypt
  cipher.key = OpenSSL::Digest::SHA256.new(password.to_s).digest
  iv = encrypted.slice!(0, 32).scan(/../).map { |x| x.hex.chr }.join

  cipher.iv = iv
  decrypted = cipher.update(encrypted) + cipher.final
  end
end 

token = Token.new
send = Send.new
check = Check.new
protect = Protect.new

# TODO LIST:
=begin
сделать шифрование ONOroom и MONOroom, сейчас есть возможность только для генерации токена шифр
ования


уже сделал:

шифровку, дешифровки еще нет.
=end

# примеры использования
=begin
puts token.user(20) # генерирует токен для user, рекомендуемые входные данные: 20
puts token.ono(20) # генерирует токен для onoroom, рекомендуемые входные данные: 20
puts token.mono(20) # генерирует токен для monoroom, рекомендуемые входные данные: 20
token.bot(20) # генерирует токен для bot, рекомендуемые входные данные: 20
send.token() # отправляет токен в tmp.bin файл, на вход принимает выше упомянутые функции
puts check.token(int/IntVar) # проверяет token который находится в tmp.bin файле, на вход принимает int или же переменную с типом int
=end

# ПРИМЕЧАНИЯ
=begin
не выполняйте функцию send асинхронно.
=end
