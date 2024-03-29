# # # # # # # # # #
# Classe Request  #
# # # # # # # # # #
#
# Synopsis : analyse morpho-syntaxique, catégorisation, extraction de mots-clés.
# Authors : Romain Deveaud, Ludovic Bonnefoy
#
# NLGbAse.QR, May 2009
#
# # # # #

class Request
    attr_reader :sent

    def initialize(request)
# La phrase tapée est parsée par l'analyseur morpho-syntaxique (LinkParser).
        @sent = $dict.parse(request)
        @sent = $dict_null.parse(request) if @sent.num_linkages_found == 0 or @sent.linkages.empty?
    end

    def diagram
        @sent.diagram
    end

    def extract
# Cette fonction va appeler successivement toutes les méthodes
# nécessaires afin d'extraire les différents mots-clés et les 
# catégories qui seront utilisés dans le système de RI.
        results = Hash.new
        ext = extract_e1_2({:label => "NP"})
        ext = ext == "" ? extract_e1 : ext
        en = en_e3(ext)
        ext = en == "" ? ext : en
        results[:kw_e1]  = ext
        results[:kw_e2]  = ext
        results[:kw_e3]  = extract_e3
        results[:cat_e2] = categorize_e2
        results[:cat_e3] = categorize_e3
        results[:en_e3]  = en
        results
    end

private
    def get_np(options = {})
        np = []
        @sent.linkages.first.links.each do |l| 
          np.push(l.lword.split(".").first.split("[").first, l.rword.split(".").first.split("[").first) if l.label =~ /G.*/
          np.push(l.rword.split(".").first.split("[").first, l.rword.split(".").first.split("[").first) if l.label =~ /DG.*/
          np.push(l.rword.split(".").first.split("[").first, l.rword.split(".").first.split("[").first) if l.label =~ /JG.*/
          np.push(l.rword.split(".").first.split("[").first, l.rword.split(".").first.split("[").first) if l.label =~ /MG.*/
        end

        np.uniq!
        if np.length > 2
          t = np.shift
          np.insert(1,t)
          np.reverse!
        end

        if np.empty?
          temp = @sent.words-["?",".","'s","LEFT-WALL","RIGHT-WALL","I"]
          temp.each { |w| np.push(w) if (w.capitalize == w or w.upcase == w)}
        end

        if options[:from] != "e3"
          np.push(extract_e1_2({:label => "NP"}).split) if np.empty?
          np.delete("")
          np.push(extract_e1_2({:label => "ADJP"}).split) if np.empty?
          np.delete("")
        end
        np.flatten!
        np -= $stoplist
        np # => /!\ C'est une Array, pas une String !!
    end

    def get_cat(word,np,options = {},offset = 1)
      cat = ""
      object = @sent.object if !@sent.object.nil?
      object = find_obj if object.nil?
      case word
          when "who", "whom", "whose" : 
            cat = "pers"
          when "where", "whence", "wither" : 
            if options[:cat] == 2
              if !np.empty?
                cat = np.join("+").categorize_np
                cat = extract_e1_2({:label => "NP"}).split.join("+").categorize_np if cat == "unk"    
              elsif !object.nil?
                cat = ActiveSupport::Inflector.singularize(object).categorize # définie dans string.rb
              else
                cat = "loc"
              end
            else
              cat = "loc"
            end
          when "when" : 
            if options[:cat] == 2
              if !np.empty?
                cat = np.join("+").categorize_np
                cat = extract_e1_2({:label => "NP"}).split.join("+").categorize_np if cat == "unk" 
              elsif !object.nil?
                cat = ActiveSupport::Inflector.singularize(object).categorize # définie dans string.rb
              else
                cat = "date"
              end
            else
              cat = "date"
            end
          when "how" :
            if options[:cat] == 2
              if !np.empty?
                cat = np.join("+").categorize_np
                cat = extract_e1_2({:label => "NP"}).split.join("+").categorize_np if cat == "unk"    
              elsif !object.nil?
                cat = ActiveSupport::Inflector.singularize(object).categorize # définie dans string.rb
              else
                cat = "unk"
              end
            else 
              if ["large","few","great","little","many","much","tall", "wide", "high", "big","long"].include?(@sent.words[offset+1])
                  cat = "amount" 
              elsif ["close","far"].include?(@sent.words[offset+1])
                  cat = "amount.phy.len" 
              elsif ["hot"].include?(@sent.words[offset+1])
                  cat = "amount.phy.temp" 
              elsif ["fast"].include?(@sent.words[offset+1])
                  cat = "amount.phy.spd" 
              elsif ["old"].include?(@sent.words[offset+1])
                  cat = "amount.phy.age" 
              elsif np.include?(object)
                cat = np.join("+").categorize_np
                cat = extract_e1_2({:label => "NP"}).split.join("+").categorize_np if cat == "unk"    
              elsif !object.nil?
                cat = ActiveSupport::Inflector.singularize(object).categorize # définie dans string.rb
              else
                cat = "unk"
              end
            end
          when "what", "why", "which" : 
#            if options[:cat] == 2
            cat = np.join("+").categorize_np if !np.empty? and options[:cat] == 2
            cat = extract_e1_2({:label => "NP"}).split.join("+").categorize_np if cat == "unk"    
#              cat = "unk" if np.empty?
            if np.empty? or cat.nil? or cat == "" 
              if !$stoplist.include?(Linguistics::EN.infinitive(@sent.words[offset+1])) and !$stoplist.include?(ActiveSupport::Inflector.singularize(@sent.words[offset+1]))
                cat = ActiveSupport::Inflector.singularize(@sent.words[offset+1]).categorize
              elsif np.include?(object)
                cat = np.join("+").categorize_np
              elsif !object.nil? 
                cat = ActiveSupport::Inflector.singularize(object).categorize # définie dans string.rb
              else 
                cat = "unk"
              end
            end
          else cat = "unk"
      end
      cat
    end

    def rewrite
        obj = extract_e1_2.split(" ")
        index = 1000
        @sent.words.each { |w| index = @sent.words.index(w) if (obj.include?(w)) && (index > @sent.words.index(w)) }
        new_sent = @sent.words-["'s","LEFT-WALL","RIGHT-WALL"]-obj

        new_sent.insert(index-1,new_obj(obj))
        puts " >> Rewriting... "+new_sent.join(" ") if $debug == true
        @sent = $dict.parse(new_sent.join(" "))
        @sent = $dict_null.parse(new_sent.join(" ")) if @sent.num_linkages_found == 0
    end

    def new_obj(obj)
        obj = obj.join("+")
        arr = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/lr_info_extractor.pl?query=#{obj}&search=EN&type=en")).split(":")
        obj = arr[0]
        obj = arr[1] if arr[0] == ""
        obj
    end

    def find_obj
      object = nil
      @sent.linkages.first.links.each { |l| object = l.rword.split(".").first.split("[").first if l.label =~ /I\*./ }
      object
    end

    def categorize_e2
        cat = ""
        np = get_np
        object = @sent.object if !@sent.object.nil?
        object = find_obj if object.nil?
        link = @sent.linkages.first.links[1]
        if @sent.words.length <= 5
          if np.empty?
              cat = ActiveSupport::Inflector.singularize(object).categorize
          else
              cat = np.join("+").categorize_np
          end
        elsif link.label =~ /W[jqs]/ 
        # Si c'est une question...
          word = link.rword
          word = @sent.words[@sent.words.index(word.capitalize)+1] if word.capitalize == "In"
          offset = @sent.words.index(word).nil? ? @sent.words.index(word.capitalize) : @sent.words.index(word)
          cat = get_cat(word,np, {:cat => 2}, offset)
        elsif @sent.linkages.first.links[0].label != "Xp" and @sent.linkages.first.links[0].label =~ /W[jqs]/
          cat = get_cat(@sent.words[1],np, {:cat => 2})
        elsif link.label =~ /W[di]|Q./ or link.lword != "LEFT-WALL"
        # Si c'est une phrase déclarative ou impérative
            if np.empty?
              cat = "unk"
            else
              cat = np.join("+").categorize_np
            end
        end
        cat = (@sent.words-["LEFT-WALL","RIGHT-WALL"]).join(" ").categorize_ccg if cat.nil?
        cat = "unk" if cat.nil? 
        cat
    end
    
    def categorize_e3
        cat = ""
        np = get_np
        object = @sent.object if !@sent.object.nil?
        object = find_obj if object.nil?
        link = @sent.linkages.first.links[1]
        if @sent.words.length <= 5
          if np.empty?
              cat = ActiveSupport::Inflector.singularize(object).categorize
          else
              cat = np.join("+").categorize_np
          end
        elsif link.label =~ /W[jqs]/ 
          word = link.rword
          word = @sent.words[@sent.words.index(word.capitalize)+1] if word.capitalize == "In"
          offset = @sent.words.index(word).nil? ? @sent.words.index(word.capitalize) : @sent.words.index(word)
          cat = get_cat(word,np, {}, offset)
        elsif @sent.linkages.first.links[0].label != "Xp" and @sent.linkages.first.links[0].label =~ /W[jqs]/
          cat = get_cat(@sent.words[1],np)
        elsif link.label =~ /W[di]|Q./ or link.lword != "LEFT-WALL"
        # Si c'est une phrase déclarative ou impérative ou si elle n'a pas été correctement écrite
          if @sent.null_count == 0
            cat = ActiveSupport::Inflector.singularize(object).categorize
          else
            cat = get_cat(@sent.words[1],np)
#            cat = get_cat(object, np)            
          end
        end
        cat = "unk" if cat.nil?
        cat
    end

    def extract_e1
        kw_array = get_np
        object = @sent.object.split(".").first.split("[").first if !@sent.object.nil?
        if !get_np.include?(object)
            kw_array.push(object) unless object.nil? 
            @sent.linkages.first.links.each do |l|
                kw_array.push(l.lword.split(".").first.split("[").first) if (l.rword.split(".").first.split("[").first == object) && (l.label =~ /A|AN/)
            end
        end
        kw_array -= $stoplist
#        kw_str = "" 
#        kw_array.each { |w| kw_str += "#{w.split(".").first} " }
#        kw_str.strip!
#        kw_str
#        kw_array.sort!        
        kw_array.join(" ")        
    end

    def extract_e1_2(options)
        kw_array = ctree_rec(@sent.constituent_tree.first, options[:label])
        kw_array -= $stoplist
#        kw_array = extract_e1 if kw_array.empty?
#        kw_array.sort!
        kw_array.join(" ")
    end

    def ctree_rec(var,label)
# Parcours récursif de l'arbre, on récupère tous les children du label NP
        array = []

        var.children.each do |c|
            array.concat(ctree_rec(c, label)) if c.children.length > 0
            array.push(c.label) if (c.children.length == 0) && (var.label == label)
        end
        array
    end

    def en_e3(keywords)
      named_ent = ""
      
      np = get_np
      if np.empty?
# On exécute une requête avec l'objet de la question pour récupérer
# le nom de la fiche associée, qui fera office d'entité nommée.
          named_ent = new_obj(keywords.split(" ")) 
      else
# On exécute une requête pour récupérer le nom exact de l'EN.      
          check = np.join("+").check_np
          named_ent = check == "" ? np.join(" ") : check.split("+").join(" ")
      end

      named_ent = "" if named_ent.nil?
      named_ent
    end
    
    def extract_e3
        keywords = []
        
        verb = []
        @sent.linkages.first.links.each do |l| 
            v = nil
            if l.lword.split(".")[1] == "v"
                v = l.lword.split(".")[0].split("[").first
            elsif l.rword.split(".")[1] == "v"
                v = l.rword.split(".")[0].split("[").first
            end
            verb.push(v); break if !v.nil?
        end

        keywords = @sent.words-$stoplist-get_np({:from => "e3"})-verb

        @sent.linkages.first.links.each do |l| 
            next if l.lword.nil? or l.rword.nil? or l.lword == "." or l.rword == "."
            if keywords.include?(l.lword.split(".")[0].split("[").first)
                symbol = case l.lword.split(".")[1]
                    when "a" : :adjective
                    when "n" : :noun
                    when "e" : :adverb
                    when "v" : :verb
                    else nil
                end
#syn = synset(ActiveSupport::Inflector.singularize(word), symbol) if synset(word, symbol).nil?
                word = l.lword.split(".")[0].split("[").first
                syn = synset(word,symbol)
                syn = syn.nil? ? synset(ActiveSupport::Inflector.singularize(word), symbol) : syn 
                syn = syn.nil? ? synset(Linguistics::EN.infinitive(word), symbol) : syn 
                keywords += syn.words if !syn.nil?
            elsif keywords.include?(l.rword.split(".")[0].split("[").first)
                symbol = case l.rword.split(".")[1]
                    when "a" : :adjective
                    when "n" : :noun
                    when "e" : :adverb
                    when "v" : :verb
                    else nil
                end
                word = l.rword.split(".")[0].split("[").first
                syn = synset(word,symbol)
                syn = syn.nil? ? synset(ActiveSupport::Inflector.singularize(word), symbol) : syn 
                syn = syn.nil? ? synset(Linguistics::EN.infinitive(word), symbol) : syn 
                keywords += syn.words if !syn.nil?
            end
        end

        if keywords.empty?
          word = find_obj
          syn = synset(word, :verb)
          syn = syn.nil? ? synset(word, :verb) : syn 
          keywords += syn.words if !syn.nil?
        end
        
        if keywords.empty?
          word = verb.to_s # un seul mot avec un .v est trouvé dans la phrase
          syn = synset(word, :verb)
          syn = syn.nil? ? synset(word, :verb) : syn 
          syn = syn.nil? ? synset(Linguistics::EN.infinitive(word), :verb) : syn 
          keywords += syn.words if !syn.nil?
          keywords.push(word)
        end

        keywords.collect! { |w| w.split(" ") }
        keywords.flatten!
        keywords.uniq!
        sec_line = keywords.join(";")
        
        return sec_line
    end
end
