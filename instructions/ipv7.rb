require 'securerandom'
def serial
SecureRandom.hex[0..3] + ':::' + SecureRandom.hex[0..6] + "::" + SecureRandom.hex[0..4] + ":::" + SecureRandom.hex[0..3]
end

 
puts serial
File.open('ip', 'a') do |destination|
  destination << serial
end
