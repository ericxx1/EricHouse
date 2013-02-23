require 'socket'
webserver = TCPServer.new('127.0.0.1', 1113)
while (session = webserver.accept)
   request = session.gets
   if(request =~ /www./)
   trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').gsub('www', '')
   session.puts "Web Servers are only half working atm!"
   else
   trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
   session.puts "Web Servers are only half working atm!"
   end
   #filename = trimmedrequest.chomp
   #if filename == ""
   #   filename = "index.html"
   #end
   #begin
   #   displayfile = File.open(filename, 'r')
   #   content = displayfile.read()
   #   session.print content
   #rescue Errno::ENOENT
   #   session.print "File not found"
   #end
   session.close
end
