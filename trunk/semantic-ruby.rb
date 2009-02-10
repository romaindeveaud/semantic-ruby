# Le fichier qui contiendra l'interface utilisateur :
#  - saisie de la requête
#  - choix du/des moteur(s) approprié(s)
#  - ...

require 'lib/loading'
require 'lib/request'

while true do
    print "Enter your request : "
    request = Request.new(str = gets)
    puts request.extract
    break if str.chomp! == "exit" # Condition de sortie
end
