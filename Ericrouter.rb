require 'socket'
require 'ipaddr'
require 'net/http'

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text)
  colorize(text, 31) 
end

def green(text) 
  colorize(text, 32)
end

def purple(text)
  colorize(text, 35)
end

def yellow(text)
  colorize(text, 33)
end

def blue(text)
  colorize(text, 34)
end

def get_ip
  con = Net::HTTP.new('checkip.dyndns.org', 80)
  resp, body = con.get("/", nil)
  ip = body.match(/\d+\.\d+\.\d+\.\d+/)
  
  ip[0]
end

my_ip = IPAddr.new(get_ip)
puts my_ip
Thread.abort_on_exception = true
@port = '4545'
urpeer = File.read("destination.txt").strip
puts '[' + purple("Your peer Destination is: ") + green(urpeer) + ']'

###########Start up your peer##############
@socket = TCPServer.new @port
s = @socket
puts "Opened Socket port #{@port}"
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
      
      if(whois =~ /AREYOU/)
        verb, odest = whois.split(":")
        if urpeer == odest
          puts "THATS ME! :O"
          puts "Your peer ID is: #{urpeer}"
          puts my_ip
          peer.puts my_ip
        else
          puts "Your peer ID is: #{urpeer}"
          puts odest
          puts "NOT ME :("
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
            puts dest
            puts "Attempting to find #{name} Port: #{webport}" 
            puts "Destination:#{dest}"
            peerlist = File.readlines("peers").each do |peers|
              peers.strip
              q = TCPSocket.new peers, @port
              q.puts "AREYOU:#{dest}"
              answer = q.gets
              puts answer
              peers.close
            end
          else
            clen = whois.gsub("http://", "").gsub("HTTP/1.1", "").gsub(/\s+/, "").gsub("GET", "")
            site, subject = clen.split("/")#web.site, /file.html
            puts site, subject
            contents = File.read("sites/#{site}")
            name, dest, webport = contents.split(":")#web.site, PEERID, webserverport
            puts "Attempting to find #{name} Port: #{webport}" 
            puts "Destination:#{dest}"
            peerlist = File.readlines("peers").each do |peers|
              peers.strip
              q = TCPSocket.new peers, @port
              q.puts "AREYOU:#{dest}"
              answer = q.gets
              puts answer
              peers.close
            end
          end
        end
      end
      
      if(whois =~ /CONNECT/)
        Thread.new do
          ircserver = whois.gsub("HTTP/1.0", "").gsub(/\s+/, "").gsub("CONNECT", "")
          irchost, ircport = ircserver.split(":")
          puts irchost
          puts ircport
          socks = TCPSocket.open(irchost, ircport)
          Thread.new do
            loop do
              peer.puts socks.gets
            end
          end
          
          loop do
            socks.puts line
          end
        end
      end
      
      ircservers = Thread.new do#New Thread
        if(whois =~ /CAP/ or whois =~ /NICK/)#This just identifies the connection as a IRC. I did it in a very gay way.
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

out = Thread.new do
  puts "Attempting to connect to peer"
  peerlist = File.readlines("peers").each do |peers|
    sleep(5)
    q = TCPSocket.new peers, @port
    q.puts "PEER"
    q.puts urpeer
    outpeer = q.gets.chomp
    puts "Connected to Peer #{outpeer}"
  end
end

local.join
routers.join
out.join
websites.join
ircservers.join
