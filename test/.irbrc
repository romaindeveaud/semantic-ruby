linkparserpath = ENV['LPPATH']
wordnetpath = ENV['WNPATH']
$LOAD_PATH.unshift( linkparserpath+"/lib", linkparserpath+"/ext" )

begin
	puts "Requiring 'linkparser' module..."
	require 'linkparser'
rescue => e
	$stderr.puts "LinkParser module failed to load : #{e.message}\n\t" +
		e.backtrace.join( "\n\t" )
end

opts = {
   :disjunct_cost => 3,
   :min_null_count => 1,
   :max_null_count => 250,
   :max_parse_time => 60,
   :islands_ok => 1,
   :short_length => 6,
   :all_short_connectors => 1,
   :linkage_limit => 100,
}
$dict      = LinkParser::Dictionary.new
$dict_null = LinkParser::Dictionary.new(opts)
$LOAD_PATH.unshift(wordnetpath+"lib")

require 'rubygems'
require 'active_support/inflector'

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
