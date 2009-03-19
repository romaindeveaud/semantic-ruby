#
# All the lines below load the libraries
linkparserpath = ENV['LPPATH']
wordnetpath = ENV['WNPATH']

$LOAD_PATH.unshift( linkparserpath+"/lib" , linkparserpath+"/ext" )

begin
	require 'linkparser'
rescue => e
	puts "LinkParser module failed to load : #{e.message}\n\t" +
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
   :verbosity => 0
}
$dict = LinkParser::Dictionary.new(:verbosity => 0)
$dict_null = LinkParser::Dictionary.new(opts)
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

$debug = false
include Linguistics::EN
Linguistics::use(:en)

require 'pathname'
require 'rubygems'
require 'active_support/inflector'

ActiveSupport::Inflector.inflections.uncountables.push("data","advice","behaviour","consent","dictation","persuasion","scorn","rugby","archery","yoga","copper","iron","oxygen","steel","sodium","clothing","equipment","furniture","luggage","money")

path = (File.basename(Pathname.pwd.to_s) == "lib") ? "" : "lib/" ;

unless File.basename(Pathname.pwd.to_s) == "test"
  require path+'string'
  enfile = File.new(path+"stoplist.en", File::RDONLY, 0644)
  $stoplist = enfile.readlines
  $stoplist.each { |w| w.chomp! }
end
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
