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
  resp = con.get("/")
  body = resp.body
  ip = body.match(/\d+\.\d+\.\d+\.\d+/)
  
  ip[0]
end

my_ip = IPAddr.new(get_ip)
puts my_ip
Thread.abort_on_exception = true
@port = '4545'
urpeer = File.read("destination.txt").strip
puts '[' + purple("Your peer Destination is: ") + green(urpeer) + ']'
def ipv7
ipv = File.read("ip")
puts "Your ipv7 address is #{ipv}"
end
ipv7
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
        odest, webport = odest.split("~")
        puts odest, webport
        odest.chomp!
        webport.chomp!
        server = peer.gets
        if urpeer == odest
          puts "THATS ME! :O"
          puts "Your peer ID is: #{urpeer}"
          puts server
          webserver = TCPSocket.open('127.0.0.1', webport) 
          webserver.puts server
          mg = webserver.gets
          peer.puts mg
          #puts my_ip
          #peer.puts my_ip
          peer.close
        else
        peer.puts "NO"
          puts "Your peer ID is: #{urpeer}"
          puts "NOT ME :("
          peer.close
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
              peers.chomp!
              q = TCPSocket.new peers, @port
              q.puts "AREYOU:#{dest}~#{webport}"
              q.puts whois
              answer = q.gets
              if(answer == "NO")
              q.close
              else
              peer.puts answer
              q.close
              peer.close
              end
            end
          else
            clen = whois.gsub("http://", "").gsub("HTTP/1.1", "").gsub(/\s+/, "").gsub("GET", "")
            site, subject = clen.split("/")#web.site, /file.html
            puts site, subject
            contents = File.read("sites/#{site}")
            name, dest, webport = contents.split(":")#web.site, PEERID, webserverport
            puts dest
            puts "Attempting to find #{name} Port: #{webport}" 
            puts "Destination:#{dest}"
            peerlist = File.readlines("peers").each do |peers|
              peers.chomp!
              q = TCPSocket.new peers, @port
              q.puts "AREYOU:#{dest}~#{webport}"
              q.puts whois
              answer = q.gets
              if(answer == "NO")
              q.close
              else
              peer.puts answer
              q.close
              peer.close
              end
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
		  irctunnel = File.read("tunnels/irctunnel")
		  irctunnel.chomp!
		  irchost, ircport = irctunnel.split(":")
		  irchost.chomp!
          irc = TCPSocket.open(irchost, ircport)#Opens a connection with the irc server
          irc.puts whois#Sends the nick to irc server
          user = peer.gets#Gets the Ident from client
          irc.puts user#sends the ident to irc server
          
          Thread.new do
            loop do#New loop
              server = irc.gets#Gets everything from server
              peer.puts server#Sends it to client
              irc.close if server =~ /^\s*$/
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
    peers.chomp!
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
