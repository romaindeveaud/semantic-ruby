#!/usr/bin/ruby

if ENV['PWD'].split("/").last != "semantic-ruby"
  puts " **Error : the server must be launch from the main semantic-ruby directory."
  exit
end
$LOAD_PATH.unshift(ENV['PWD']+"/lib", ENV['PWD']+"/www")

require 'loading'
require 'request'
require 'readline'
require 'socket'
require 'rexml/document'
require 'xmllistener'

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
      res1 = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/rr_info_extractor_xml.pl?ename=#{results[:cat_e2]}&terms=#{results[:kw_e1].split.join("+")}&search=EN"))
      listener = XMLlistener.new
      parser = Parsers::StreamParser.new(res1, listener)
      parser.parse
      res = "<br /><big><span style='font-weight: bold; margin-left : 50px;'>Semantic search, basic</span></big>#{listener.get_doc}"
      res2 = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/rr_info_extractor_xml.pl?query=#{results[:kw_e1].split.join("+")}&search=EN"))
      listener = XMLlistener.new
      parser = Parsers::StreamParser.new(res2, listener)
      parser.parse
      res += "<br /><big><span style='font-weight: bold; margin-left : 50px;'>Simple search</span></big>#{listener.get_doc}"
    rescue NoMethodError,URI::InvalidURIError 
      result+= "Execution error. Maybe your sentence has not been written properly."
    end
    sock.print res#ult
  rescue Errno::EAGAIN, Errno::ECONNABORTED, Errno::EPROTO, Errno::EINTR
    IO.select([serv])
    retry
  end
end
