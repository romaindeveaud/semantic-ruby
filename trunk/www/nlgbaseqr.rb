#!/usr/bin/ruby

require 'socket'
require 'cgi'

cgi  = CGI.new("html3")
sock = TCPSocket.new("localhost","12005")

cgi.out() do
#  cgi.html() do
#    cgi.head{ cgi.title{"NLGbAse.QR"} } +
#    cgi.body() do
      if cgi.params.has_key?("request")
        sock.print cgi.params["request"]
        results = sock.recvfrom(1000000)[0]+"<br /><a href='http://sit.vickev.fr/semantic-ruby/www/'>Back home</a>"
        results
      else
        CGI::escapeHTML("Failure !")
      end
#    end
#  end
end
#puts "Content-Type: text/html"
#puts
#puts "<html>"
#puts "<body>"
#puts "<h1>#{ENV['CONTENT_TYPE']}</h1>"
#puts "</body>"
#puts "</html>"

