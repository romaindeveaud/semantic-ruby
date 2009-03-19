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

def evaluate
  errors = 0
  questions = File.new("test/eval_questions").readlines
  questions.collect! { |q| q.strip! }
  questions.each do |q|
    q = q.split("#")
    question  = q[0]
    kw_e1_e2  = q[1]
    cat_e2    = q[2].split(".")[0]
    en_e3     = q[3]
    kw_e3     = q[4]
    cat_e3    = q[5].split(".")[0]

    request = Request.new(question)
    begin
      result  = request.extract
    rescue  => e
        errors += 1
        puts e.message+" [#{question}]"
        puts e.backtrace
    end
  end
  puts "There was #{errors.to_s} execution errors (#{errors.to_f*100/questions.length.to_f}%)."
end

$debug = true if ARGV[0] == "--debug"
loop do
    str = prompt("Enter your request : ")
    break if str == "exit" # Condition de sortie
    if str == "eval"
      evaluate
      break
    end
    request = Request.new(str)
    begin
      results = request.extract
      puts "Keywords selected for engine 1 : "+results[:kw_e1]
      print "Keywords selected for engine 2 : "
      puts "[#{results[:cat_e2]}] #{results[:kw_e2]}"
      print "Keywords selected for engine 3 : "
      puts "[#{results[:cat_e3]}] [Named entity : #{results[:en_e3]}] [Keywords : #{results[:kw_e3]}]"
#    rescue NoMethodError
#      $stderr.puts "Execution error. Maybe your sentence has not been written properly."
    end
end
