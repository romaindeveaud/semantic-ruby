require 'rubygems'        # if you use RubyGems
require 'daemons'

if ENV['PWD'].split("/").last != "semantic-ruby"
  puts " **Error : the server must be launch from the main semantic-ruby directory."
  exit
end

Daemons.run('www/semantic-ruby_server.rb')
