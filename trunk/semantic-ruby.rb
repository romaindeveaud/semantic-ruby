# Le fichier qui contiendra l'interface utilisateur :
#  - saisie de la requête
#  - choix du/des moteur(s) approprié(s)
#  - ...

require 'lib/loading'
require 'lib/request'
require 'readline'

def prompt(prompt)
# Fonction permettant de gérer l'historique de saisie des requêtes
# ainsi que le déplacement avec les flèches gauches et droites.
    input = nil
    prompt += " " unless prompt =~ /\s$/
    loop do
        input = Readline.readline(prompt, true)
        break if input.length > 0
    end
    input
end

loop do
    str = prompt("Enter your request : ")
    break if str == "exit" # Condition de sortie
    request = Request.new(str)
    begin
      request.extract
    rescue NoMethodError
      $stderr.puts "Your sentence seems to be miswritten, please take the time to check it."
    end
end
