require 'socket'
require 'ipaddr'
require 'net/http'
require_relative 'colorize'

module EricHouse
  class Peer
    include EricHouse::Colorize
    
    def initialize
      @port = '4545'
      unless File.exist? 'destination.txt'
        require_relative 'instructions/dest'
      end
      @urpeer = File.read 'destination.txt'
      get_my_ip
      puts @my_ip
      puts "[#{purple 'Your peer Destination is: '}#{green @urpeer}]"
      
      Thread.abort_on_exception = true
      start_peer
    end
    
    def get_my_ip
      http = Net::HTTP.new 'whatismyip.akamai.com', 80
      @my_ip = IPAddr.new http.get("/").body
    end
    
    def start_peer
      @socket = TCPServer.new @port
      puts "Opened socket, port #{@port}"
      
      local
      out
      join
    end
    
    def local
      @local = Thread.new do
        puts 'Client now accepting fellow peers'
        
        loop do
          Thread.start @socket.accept do |peer|
            puts "Incoming connection"
            whois = @peer.gets
            puts whois
            
            @routers = Thread.new do
              if(whois =~ /PEER/)
                @cntpeername = @peer.gets.chomp
                @peername = @peer.puts @urpeer
                puts "Peer #{@cntpeername} connected"
              end
            end
            
            if(whois =~ /AREYOU/)
              verb, odest = whois.split(":")
              if @urpeer == odest
                puts "THATS ME! :O"
                puts "Your peer ID is: #{@urpeer}"
                puts @my_ip
                peer.puts @my_ip
              else
                puts "Your peer ID is: #{@urpeer}"
                puts odest
                puts "NOT ME :("
              end
            end
            
            @websites = Thread.new do
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
            
            @ircservers = Thread.new do#New Thread
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
      
      def out
        @out = Thread.new do
          puts "Attempting to connect to peer"
          peerlist = File.readlines("peers").each do |peers|
            peers.chomp!
            sleep(5)
            q = TCPSocket.new peers, @port
            q.puts "PEER"
            q.puts @urpeer
            outpeer = q.gets.chomp
            puts "Connected to Peer #{outpeer}"
          end
        end
      end
      
      def join
        @local.join
        @routers.join
        @out.join
        @websites.join
        @ircservers.join
      end
    end
  end
end

EricHouse::Peer.new
