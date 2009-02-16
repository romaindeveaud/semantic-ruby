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
        if @sent.linkages.first.links[1].label =~ /W.*/
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
                else cat = "unk"
            end
        end
    end
    
    def categorize_e3
        cat = ""
        if @sent.linkages.first.links[1].label =~ /W.*/
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
                    np = get_np
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
                        cat = @sent.object.split(".").first.categorize # définie dans string.rb
                    end
                else cat = "unk"
            end
        end
        cat
    end

    def extract_e1
        kw_array = get_np
        object = @sent.object.split(".").first if !@sent.object.nil?
        if !get_np.include?(object)
            kw_array.push(object) unless object.nil? 
            @sent.linkages.first.links.each do |l|
                kw_array.push(l.lword.split(".").first) if (l.rword.split(".").first == object) && (l.label =~ /A.*/)
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
        
        if get_np == ""
            req = extract_e1_2
# Executer la requête sur le premier moteur et récupérer le meilleur
# résultat, qui sera l'entité nommée.
            named_ent = "[No named_ent in this question]"
        else
            named_ent = get_np.join(" ")
        end

        return "[Named entity : #{named_ent}] [Keywords : #{keywords}]"
    end
end
