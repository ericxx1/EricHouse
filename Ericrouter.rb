require 'socket'


def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end
def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def purple(text); colorize(text, 35); end
def yellow(text); colorize(text, 33); end
def blue(text); colorize(text, 34); end
 
Thread.abort_on_exception = true
   
port = '4545'



urpeer = File.read("destination.txt").strip
puts '[' + purple("Your peer Destination is: ") + green(urpeer) + ']'




###########Start up your peer##############
@socket = TCPServer.new port
s = @socket
puts "Opened Socket port #{port}"
local = Thread.new do
puts "Client now accepting fellow peers"
loop do
Thread.start(s.accept) do |peer|
puts "Incoming connection"
whois = peer.gets
puts whois

routers = Thread.new do
if(whois =~ /PEER/)
	cntpeername = peer.gets.chomp
	peername = peer.puts urpeer
	puts "Peer #{cntpeername} connected"
	#if(peer.close)
	#puts "Peer disconnected"
	#end
end
end

websites = Thread.new do
if(whois =~ /GET/)
	if(whois =~ /www/)
	clen = whois.gsub("http://", "").gsub("HTTP/1.1", "").gsub("www.", "").gsub(/\s+/, "").gsub("GET", "")
	puts clen
	site, subject = clen.split("/")#web.site, /file.html
	puts site, subject
	contents = File.read("sites/#{site}")
	name, dest, webport = contents.split(":")#web.site, PEERID, webserverport
	puts "Attempting to find #{name} Peer: #{dest} Port: #{webport}"
	puts "Sending AreYouPeer request throughout network"
	#Send dest to each peet somehow
	#peer.puts dest 
	else
	clen = whois.gsub("http://", "").gsub("HTTP/1.1", "").gsub(/\s+/, "").gsub("GET", "")
	site, subject = clen.split("/")#web.site, /file.html
	puts site, subject
	contents = File.read("sites/#{site}")
	name, dest, webport = contents.split(":")#web.site, PEERID, webserverport
	puts "Attempting to find #{name} Peer: #{dest} Port: #{webport}"
	puts "Sending AreYouPeer request throughout network"
	#Send dest to each peet somehow
	#peer.puts dest 
	end
	end
end

ircservers = Thread.new do#New Thread
if(whois =~ /NICK/)#This just identifies the connection as a IRC. I did it in a very gay way.
	irc = TCPSocket.open("irc.cmpct.info", "6667")#Opens a connection with the irc server
	irc.puts whois#Sends the nick to irc server
	puts "Sent nickname to irc server"
	user = peer.gets#Gets the Ident from client
	irc.puts user#sends the ident to irc server
	puts "Sent in ident"
	
	Thread.new do
	loop do#New loop
	server = irc.gets#Gets everything from server
	peer.puts server#Sends it to client
	p
	end
	
	end
	Thread.new do 
	loop do
	info = peer.gets
	irc.puts info
	end
  end
end
end	
end 
end 
end
##########################################




#####Start connecting to other peers#####
out = Thread.new do
  puts "Attempting to connect to peer"
  peerlist = File.readlines("peers").each do |peers|
  peers.strip
  sleep(5)
  q = TCPSocket.new peers, '4545'
  q.puts "PEER"
  q.puts urpeer
  outpeer = q.gets.chomp
  puts "Connected to Peer #{outpeer}"
  ##NOT DONE PEERID 2##
  	#If peerID equals there peerID send back webserver info
	#Connect to webserver
  Thread.new do
	odest= q.gets
	puts odest
		if(urpeer == odest)
		puts "Yes I am peer #{odest}"
		
		elsif urpeer != odest
		puts "Thats not me!"
		end
		end
  end
end  
#########################################

local.join
out.join


