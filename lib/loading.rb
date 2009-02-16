#
# All the lines below load the libraries
linkparserpath = ENV['LPPATH']
wordnetpath = ENV['WNPATH']
$LOAD_PATH.unshift( linkparserpath+"lib", linkparserpath+"ext" )

begin
	require 'linkparser'
rescue => e
	$stderr.puts "LinkParser module failed to load : #{e.message}\n\t" +
		e.backtrace.join( "\n\t" )
end

$dict = LinkParser::Dictionary.new
$LOAD_PATH.unshift(wordnetpath+"lib")

begin
	require 'wordnet'
rescue => e
	$stderr.puts "WordNet failed to load : #{e.message}\n\t" +
		e.backtrace.join( "\n\t" )
end

$lex = WordNet::Lexicon.new("/usr/share/ruby-wordnet")

begin
require 'linguistics'
rescue => e
    $stderr.puts "Linguistics failed to load : #{e.message}\n\t" +
        e.backtrace.join( "\n\t" )
end

include Linguistics::EN

require 'pathname'

path = (File.basename(Pathname.pwd.to_s) == "lib") ? "" : "lib/" ;
enfile = File.new(path+"stoplist.en", File::RDONLY, 0644)

require path+'string'
$stoplist = enfile.readlines
$stoplist.each { |w| w.chomp! }
#
# End of loading stuff

#puts "\nIs linkparser correctly loaded? => "+Linguistics::EN.has_link_parser?.to_s
#puts "Is wordnet correctly loaded? => "+Linguistics::EN.has_wordnet?.to_s

#print "Enter your question : "
#question = gets
#sent = sentence(question)
#puts sent.diagram
#puts sent.linkages.first.constituent_tree_string
#puts sent.linkages.first.links_and_domains
