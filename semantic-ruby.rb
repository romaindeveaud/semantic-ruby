# Le fichier qui contiendra l'interface utilisateur :
#  - saisie de la requête
#  - choix du/des moteur(s) approprié(s)
#  - ...

require 'lib/loading'
require 'lib/request'

while true do
    print "Enter your request : "
    str = gets.chomp!
    break if str == "exit" # Condition de sortie
    request = Request.new(str)
    puts request.extract
end
