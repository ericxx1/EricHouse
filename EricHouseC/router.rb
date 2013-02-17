require 'socket'
port = '5656'
@socket = TCPServer.new port
s = @socket
puts "Opened Socket port #{port}"
local = Thread.new do
puts "Client now accepting fellow peers"
loop do
Thread.start(s.accept) do |peer|
request = peer.gets
puts request
puts "Sending out info"
mserver = TCPSocket.open("109.169.73.105", port)
mserver.puts request
puts "Sent Info"
loop do 
msg = mserver.gets
if(msg =~ /nil/)
mserver.close
end
peer.puts
end
end
end
end
local.join
