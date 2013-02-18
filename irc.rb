require 'socket'
 
proxy = TCPServer.open(12345)
peer = proxy.accept
 
irc = TCPSocket.open("irc.freenode.net", 6667)
 
Thread.new do
  loop do
    peer.puts irc.gets
  end
end
 
loop do
  irc.puts peer.gets
end
