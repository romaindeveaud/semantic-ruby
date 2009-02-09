basedir = File.expand_path(".").split("/").last

if basedir == "test" 
    require '../lib/loading'
elsif basedir == "semantic-ruby" 
    require 'lib/loading'
end


puts "\nIs linkparser correctly loaded? => "+Linguistics::EN.has_link_parser?.to_s
puts "Is wordnet correctly loaded? => "+Linguistics::EN.has_wordnet?.to_s

print "Enter your question : "
question = gets
sent = sentence(question)
puts sent.diagram
puts sent.linkages.first.constituent_tree_string
puts sent.linkages.first.links_and_domains
