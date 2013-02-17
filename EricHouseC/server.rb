require 'socket'
port = '5656'
@socket = TCPServer.new port
s = @socket
puts "Opened Socket port #{port}"
local = Thread.new do
puts "EricHouse Server started..."
loop do
Thread.start(s.accept) do |client|
puts "Incoming connection"
request = client.gets
site = request.gsub("http://", "").gsub("HTTP/1.1", "").gsub("www.", "").gsub(/\s+/, "").gsub("GET", "").gsub("/", "")
puts site
website = File.read("sites/#{site}")
host, port = website.split(":")
peer = TCPSocket.open(website, port)
peer.puts request
loop do 
info = peer.gets
if(info =~ /nil/)
peer.close
break
end
client.puts info
end
end
end
end
local.join
