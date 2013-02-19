require "socket"

def socket
server = "127.0.0.1"
port = "4545"
nick = "bot|eh"
channel = "#brows"
	s = TCPSocket.open(server, port)
	s.puts "NICK #{nick}"
	s.puts "USER eh 0 * bot"
	s.puts "JOIN #{channel}"
	puts "Init up and running!"
until s.eof? do
  msg = s.gets
  puts msg
  f, g = msg.split("!")
  j, h = f.split(":")
  if(msg =~ /helpop/)
  fail, baii = msg.split("help")
  s.puts"NOTICE #{h} :***** Init Help *****"
  s.puts"NOTICE #{h} :The following commands are available:"
  s.puts"NOTICE #{h} :links               List eric's anon sites. Usage: links"    
  s.puts"NOTICE #{h} :op                  Op yourself             Usage: op"      
  s.puts"NOTICE #{h} :***** End of Help *****"
  end
if(msg =~ /!links/)
  garb, person = msg.split("!links")
  victim = person.split(" ")
  s.puts"PRIVMSG #{channel} : i2p:n3yi56racvq7nabcswkbwwqm73mjorolggnvmynsbvgcc3ehqzka.b32.i2p"
  s.puts"PRIVMSG #{channel} : Tor:2vmrphusp4pfhh5f.onion"  
end
if(msg =~ /operator/)
  garb, person = msg.split("op")
  victim = person.split(" ")
  s.puts"MODE #{channel} +o #{h}"
  s.puts"NOTICE #{h} Init has opped you!"
end
if(msg =~ /PING/)
s.puts("PONG")
end
s.puts("PONG")
end
end
socket
