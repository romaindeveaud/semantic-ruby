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
        results = sock.recvfrom(1000000)[0]#+"<br /><a href='http://sit.vickev.fr/semantic-ruby/www/'>Back home</a>"
#        results
        "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">
        <html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'> 
          <head> 
            <meta http-equiv='content-type' content='text/html;charset=UTF-8' /> 
            <title>NLGbAse.QR</title> 
            <style type='text/css' media='screen'>
                <!-- @import url( http://www.nlgbase.org/model.css ); -->
            </style>

          </head> 
          <body> 
          <div id='header'>
          <h1><a href='http://www.nlgbase.org'>NLGbAse.QR</a></h1>

          </div>
          <a href='http://www.nlgbase.org'> </a>
          <div class='pages'>
          <ul>
          <li class='current_page_item'><a href='http://sit.vickev.fr/semantic-ruby/www/'>Home</a></li>
          <li class='page_item page-item-10'><a href='http://www.nlgbase.org/'>NLGbAse</a></li>
          </ul>
          </div>#{results}</td></tr></table></pre></body></html>"
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

