#!/usr/bin/ruby

if ENV['PWD'].split("/").last != "semantic-ruby"
  puts " **Error : the server must be launch from the main semantic-ruby directory."
  exit
end
$LOAD_PATH.unshift(ENV['PWD']+"/lib")

require 'loading'
require 'request'
require 'readline'
require 'socket'

serv = TCPServer.new(12005)
puts " ** NLGbAse.QR server is running... ** "

loop do  
  begin
    sock = serv.accept_nonblock
    request = Request.new(sock.recvfrom(150)[0])
    result = ""
    begin
      results = request.extract
      result += "Keywords selected for engine 1 : "+results[:kw_e1]+"<br />"
      result += "Keywords selected for engine 2 : "
      result += "[#{results[:cat_e2]}] #{results[:kw_e2]}<br />"
      result += "Keywords selected for engine 3 : "
      result += "[#{results[:cat_e3]}] [Named entity : #{results[:en_e3]}] [Keywords : #{results[:kw_e3]}]<br />"
    rescue NoMethodError,URI::InvalidURIError 
      result+= "Execution error. Maybe your sentence has not been written properly."
    end
    sock.print result
  rescue Errno::EAGAIN, Errno::ECONNABORTED, Errno::EPROTO, Errno::EINTR
    IO.select([serv])
    retry
  end
end
