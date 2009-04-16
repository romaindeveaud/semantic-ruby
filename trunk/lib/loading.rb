#
# All the lines below load the libraries
require 'rubygems'
linkparserpath = ENV['PWD']+"/.semantic-rubyInstall/linkparser"
wordnetpath = ENV['PWD']+"/.semantic-rubyInstall/wordnet-0.0.5"
linguisticspath = ENV['PWD']+"/.semantic-rubyInstall/linguistics"
$LOAD_PATH.unshift( linkparserpath+"/lib" , linkparserpath+"/ext" )
$LOAD_PATH.unshift(wordnetpath+"/lib")
$LOAD_PATH.unshift(linguisticspath+"/lib")
$LOAD_PATH.unshift(ENV['PWD']+"/lib")


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
$dict = LinkParser::Dictionary.new("en", :verbosity => 0)
$dict_null = LinkParser::Dictionary.new("en", opts)

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
require 'active_support/inflector'

ActiveSupport::Inflector.inflections.uncountables.push("data","advice","behaviour","consent","dictation","persuasion","scorn","rugby","archery","yoga","copper","iron","oxygen","steel","sodium","clothing","equipment","furniture","luggage","money")

path = (File.basename(Pathname.pwd.to_s) == "lib") ? "" : "lib/" ;

unless File.basename(Pathname.pwd.to_s) == "test"
  require 'string'
  enfile = File.new(ENV['PWD']+"/"+path+"stoplist.en", File::RDONLY, 0644)
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
