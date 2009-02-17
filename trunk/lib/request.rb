require 'rubygems'
require 'active_support/inflector'

class Request
    attr_reader :sent

    def initialize(request)
        @sent = sentence(request)
    end

    def diagram
        @sent.diagram
    end

    def get_np
        np = []
        @sent.linkages.first.links.each { |l| np.push(l.lword.split(".").first, l.rword.split(".").first) if l.label == "G" }
        np.uniq!
        if np.length > 2
            t = np.shift
            np.insert(1,t)
            np.reverse!
        end
        np # => /!\ C'est une Array, pas une String !!
    end

    def rewrite
        print "On réécrit la requête..."
    end

# Les deux fonctions ci-dessous vont analyser la requête pour choisir
# le moteur qui convient le mieux, puis elles appeleront les fonctions
# privées suivant le résultat.
    def categorize
    end

    def extract
        print "Keywords selected for engine 1 : "
        rewrite if extract_e1_2 == ""
        puts extract_e1_2
        print "Keywords selected for engine 2 : "
        puts "[#{categorize_e2}] #{extract_e1}"
        print "Keywords selected for engine 3 : "
        puts "[#{categorize_e3}] #{extract_e3}"
    end

private
    def categorize_e2
        cat = ""
        np = get_np
        if @sent.linkages.first.links[1].label =~ /W[jqs]/
        # Si c'est une question...
            case @sent.linkages.first.links[1].rword
                when "who", "whom", "whose" : cat = "pers"
                when "where", "whence", "wither" :
                # si il n'y a pas d'entité nommée on prend la catégorie 'place', sinon
                # on prend la catégorie de l'entité nommée
                    if np.empty? 
                        cat = "place"
                    else 
                        cat = np.join("+").categorize_np
                    end
                when "when" :
                # on récupère la catégorie de l'entité nommée, sinon cat = "unk"                    
                    if np.empty? 
                        cat = "unk"
                    else 
                        cat = np.join("+").categorize_np
                    end
                when "what" :
                    if np.empty?
                        cat = ActiveSupport::Inflector.singularize(@sent.object.split(".").first).categorize
                    else
                        cat = np.join("+").categorize_np
                    end
                else cat = "unk"
            end
        elsif @sent.linkages.first.links[1].label =~ /W[di]/
        # Si c'est une phrase déclarative ou impérative
            if np.empty?
            else
                cat = np.join("+").categorize_np
            end
        end
        cat
    end
    
    def categorize_e3
        cat = ""
        np = get_np
        object = @sent.object.split(".").first if !@sent.object.nil?
        if @sent.linkages.first.links[1].label =~ /W[jqs]/
            case @sent.linkages.first.links[1].rword
                when "who", "whom", "whose" : cat = "pers"
                when "where", "whence", "wither" : cat = "place"
                when "when" : cat = "date"
                when "how" :
                    if ["few","great","little","many","much"].include?(@sent.linkages.first.links[2].rword)
                        cat = "quantity"
                    elsif ["tall", "wide", "high", "big"].include?(@sent.linkages.first.links[2].rword)
                        cat = "amount" 
                    end
                when "what" : 
                    if np.include?(@sent.object.split(".").first)
#                        noun = ""
#                        @sent.linkages.first.links.each do |l|
#                            if l.label =~ /O.*/ or l.label =~ /S.*/
#                                lword = l.lword.split(".")
#                                rword = l.rword.split(".")
#                                noun += lword[0] if lword[1] == "n"
#                                noun += rword[0] if rword[1] == "n"
#                            end
#                        end
                        cat = np.join("+").categorize_np
                    else 
                        cat = ActiveSupport::Inflector.singularize(object.categorize) # définie dans string.rb
                    end
                else cat = "unk"
            end
        elsif @sent.linkages.first.links[1].label =~ /W[di]/
        # Si c'est une phrase déclarative ou impérative
            cat = object.categorize
            cat = ActiveSupport::Inflector.singularize(object).categorize
        end
        cat
    end

    def extract_e1
        kw_array = get_np
        object = @sent.object.split(".").first if !@sent.object.nil?
        if !get_np.include?(object)
            kw_array.push(object) unless object.nil? 
            @sent.linkages.first.links.each do |l|
                kw_array.push(l.lword.split(".").first) if (l.rword.split(".").first == object) && (l.label =~ /A[N]/)
            end
        end
#        kw_str = "" 
#        kw_array.each { |w| kw_str += "#{w.split(".").first} " }
#        kw_str.strip!
#        kw_str
        kw_array.join(" ")        
    end

    def extract_e1_2
        kw_array = ctree_rec(@sent.constituent_tree.first)
        kw_array -= $stoplist
        kw_array = extract_e1 if kw_array.empty?
        kw_array.join(" ")
    end

    def ctree_rec(var)
# Parcours récursif de l'arbre, on récupère tous les children du label NP
        array = []

        var.children.each do |c|
            array.concat(ctree_rec(c)) if c.children.length > 0
            array.push(c.label) if (c.children.length == 0) && (var.label == "NP")
        end
        array
    end
    
    def extract_e3
        named_ent  = ""
        keywords   = ""
        
        if get_np.empty?
# On exécute une requête avec l'objet de la question pour récupérer
# le nom de la fiche associée, qui fera office d'entité nommée.
            named_ent = "[No named_ent in this question]"
        else
# On exécute une requête pour récupérer le nom exact de l'EN.        
            named_ent = get_np.join(" ")
        end

        verb = []
        @sent.linkages.first.links.each do |l| 
            v = nil
            if l.lword.split(".")[1] == "v"
                v = l.lword.split(".")[0]
            elsif l.rword.split(".")[1] == "v"
                v = l.rword.split(".")[0]
            end
            verb.push(v) if !v.nil?
        end

        keywords = @sent.words-$stoplist-get_np-verb

        @sent.linkages.first.links.each do |l| 
            if keywords.include?(l.lword.split(".")[0])
                symbol = case l.lword.split(".")[1]
                    when "a" : :adjective
                    when "n" : :noun
                    when "e" : :adverb
                    else nil
                end
                word = l.lword.split(".")[0]
                syn = synset(ActiveSupport::Inflector.singularize(word), symbol) if synset(word, symbol).nil?
                keywords += syn.words if !syn.nil?
            elsif keywords.include?(l.rword.split(".")[0])
                symbol = case l.rword.split(".")[1]
                    when "a" : :adjective
                    when "n" : :noun
                    when "e" : :adverb
                    else nil
                end
                syn = synset(l.rword.split(".")[0], symbol)
                syn = synset(ActiveSupport::Inflector.singularize(word), symbol) if synset(word, symbol).nil?
                keywords += syn.words if !syn.nil?
            end
        end

        keywords.collect! { |w| w.split(" ") }
        keywords.flatten!
        keywords.uniq!
        sec_line = keywords.join(";")
        
        return "[Named entity : #{named_ent}] [Keywords : #{sec_line}]"
    end
end
