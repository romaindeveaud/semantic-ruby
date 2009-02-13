linkparserpath = "/home/ubuntu/trashInstall/linkparser/trunk/"
wordnetpath = "/home/ubuntu/trashInstall/wordnet/wordnet-0.0.5/"
$LOAD_PATH.unshift( linkparserpath+"lib", linkparserpath+"ext" )

begin
	puts "Requiring 'linkparser' module..."
	require 'linkparser'
rescue => e
	$stderr.puts "LinkParser module failed to load : #{e.message}\n\t" +
		e.backtrace.join( "\n\t" )
end

$dict = LinkParser::Dictionary.new("en")
$LOAD_PATH.unshift(wordnetpath+"lib")

begin
	puts "Requiring 'wordnet' module..."
	require 'wordnet'
rescue => e
	$stderr.puts "WordNet failed to load : #{e.message}\n\t" +
		e.backtrace.join( "\n\t" )
end

$lex = WordNet::Lexicon.new("/usr/share/ruby-wordnet")

begin
puts "Requiring 'linguistics'..."
require 'linguistics'
rescue => e
    $stderr.puts "Linguistics failed to load : #{e.message}\n\t" +
        e.backtrace.join( "\n\t" )
end

puts "\nCalling Linguistics::EN module..."
include Linguistics::EN

puts "\nIs linkparser correctly loaded? => "+Linguistics::EN.has_link_parser?.to_s
puts "Is wordnet correctly loaded? => "+Linguistics::EN.has_wordnet?.to_s
