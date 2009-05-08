require 'rexml/streamlistener'
include REXML

class XMLlistener
   include StreamListener

   def initialize
    @finaldoc = String.new
    @text = nil
   end

   def tag_start(name, attributes)
    case name
        when "allresults" :
#          @finaldoc += "<a href=\"/search/show/"+attributes["xlink:href"].chomp!(".xml")+"\">"
          @finaldoc = "<pre><table style='text-align:left;margin-left:50px;margin-right:auto;font-size:1.3em;line-height:70%' border='0'><tr><td><br>"
        when "exact_matches" :
          @finaldoc += "*Exact match<br><br>"
        when "results" :
          @finaldoc += "<br>*Below is classical engine search:<br><br><br>"
        when "match","content" :
          @finaldoc += "<img alt='en' WIDTH=6 HEIGHT=5 src='http://nlgbase.org/images/en.png'> <a href='http://en.wikipedia.org/wiki/"
          @text = 1
    end
   end

   def text(text)
#    if @spaceneeded == 1 && ((text[0,1].to_s.gsub(/(\s|\W|[sS])/, " ") != " ") || text[0,1] == "(")
#     @finaldoc += " " 
#     @spaceneeded = nil
#    end
#    @finaldoc += text if @conversionwarning.nil?
#    if @match == true


      @finaldoc += "#{text}'>#{text}</a> <a href='http://www.nlgbase.org/perl/display.pl?query=#{text}" if @text == 1
      @text = nil
#      @match = false 
#    end
#    @conversionwarning = nil
   end

   def tag_end(name)
    case name
      when "allresults" :
        @finaldoc += "</td></tr></table></pre>"
      when "match","content" : 
        @finaldoc += "&search=EN'>Graph</a> <br><br>"
    end
   end

   def get_doc
    @finaldoc
   end

end

