# Le fichier qui contiendra l'interface utilisateur :
#  - saisie de la requête
#  - choix du/des moteur(s) approprié(s)
#  - ...

require 'lib/loading'
require 'lib/request'
require 'readline'

$debug = true if ARGV[0] == "--debug"
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
  precision = Hash.new
  recall    = Hash.new

  errors = 0
  i = 0
  questions = File.new("test/eval_questions").readlines
  questions.collect! { |q| q.strip! }
  questions.each do |q|
    i+=1
    q = q.split("#")
    question  = q[0]
    kw_e1_e2  = q[1]
    cat_e2    = q[2].split(".")[0]
    en_e3     = q[3].strip!
    kw_e3     = q[4].strip!
    cat_e3    = q[5].split(".")[0].strip!
    
   
    request = Request.new(question)
    results = Hash.new
    begin
      results = request.extract
    rescue  => e
      errors += 1
      puts e.message+" [#{question}]"
      puts e.backtrace
    end

    recall[cat_e2] = [0, 0] if recall.has_key?(cat_e2) == false
    recall[cat_e3] = [0, 0] if recall.has_key?(cat_e3) == false
    recall[results[:cat_e2]] = [0, 0] if recall.has_key?(results[:cat_e2]) == false
    recall[results[:cat_e3]] = [0, 0] if recall.has_key?(results[:cat_e3]) == false
    precision[cat_e2] = [0, 0] if precision.has_key?(cat_e2) == false
    precision[cat_e3] = [0, 0] if precision.has_key?(cat_e3) == false
    precision[results[:cat_e2]] = [0, 0] if precision.has_key?(results[:cat_e2]) == false
    precision[results[:cat_e3]] = [0, 0] if precision.has_key?(results[:cat_e3]) == false

    recall[cat_e2][1] += 1
    precision[results[:cat_e2]][1] += 1
    if cat_e2 == results[:cat_e2]
      recall[cat_e2][0] += 1
      precision[cat_e2][0] += 1
    end
    if cat_e3 != ""
      recall[cat_e3][1] += 1
      precision[results[:cat_e3]][1] += 1
      if cat_e3 == results[:cat_e3]
        recall[cat_e3][0] += 1
        precision[cat_e3][0] += 1
      end
    end

    puts i.to_s+". "+question+"\n\tKeywords\t (engine 1 and 2) from corpus : ["+kw_e1_e2+"] <=> extracted : ["+results[:kw_e1]+"]\n \tCategory\t (engine 2) from corpus : ["+cat_e2+"] <=> extracted ["+results[:cat_e2]+"]\n \tCategory\t (engine 3) from corpus : ["+cat_e3+"] <=> extracted : ["+results[:cat_e3]+"]\n \tNamed Entity\t (engine 3) from corpus : ["+en_e3+"] <=> extracted : ["+results[:en_e3]+"]\n \tKeywords\t (engine 3) from corpus : ["+kw_e3+"] <=> extracted : ["+results[:kw_e3]+"]\n\n"
  end
  puts "There was #{errors.to_s} execution errors (#{errors.to_f*100/questions.length.to_f}%)."
  
  global_prec = 0
  global_rec  = 0
  i = 0
  j = 0
  
  puts "Precision : "
  precision.each_pair do |key, value| 
    if value[1] > 0
      val = value[0].to_f/value[1].to_f
      puts "\t#{key} : #{val}"
      global_prec += val
      i += 1
    end
  end

  puts "Recall : "
  recall.each_pair    do |key, value| 
    if value[1] > 0 
      val = value[0].to_f/value[1].to_f
      puts "\t#{key} : #{val}" 
      global_rec += val
      j += 1
    end
  end
  puts "\nGlobal precision : #{global_prec.to_f/i.to_f}"
  puts "Global recall    : #{global_rec.to_f/j.to_f}"
end

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
    rescue NoMethodError
      $stderr.puts "Execution error. Maybe your sentence has not been written properly."
    end
end
