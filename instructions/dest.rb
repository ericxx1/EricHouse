require 'securerandom'
CLIENT_CODE = 'EH' # two-digit client code
VERSION = '0.0.1' # three-digit version number

urpeer = SecureRandom.hex[0..20] #20-byte peer-id
urpeer[0..6] = "-#{CLIENT_CODE}#{VERSION.delete('.')}-"

File.open('destination.txt', 'w') do |destination|
  destination << urpeer
end
