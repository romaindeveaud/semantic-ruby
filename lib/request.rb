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
        @sent.linkages.first.links.each { |l| np.push(l.lword, l.rword) if l.label == "G" }
        np.uniq!
        if np.length > 2
            t = np.shift
            np.insert(1,t)
            np.reverse!
        end
        np
    end

    def rewrite
        puts "On réécrit la requête..."
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
    end

private
    def categorize_e2
        cat = ""
        if @sent.linkages.first.links[1].label =~ /W.*/
            case @sent.linkages.first.links[1].rword
                when "who", "whom", "whose" : cat = "pers"
                when "where", "whence", "wither" :
# si il n'y a pas d'entité nommée on prend la catégorie 'place', sinon
# on prend la catégorie de l'entité nommée
                    np = get_np
                    if np.empty? 
                        cat = "place"
                   # elsif
# on va chercher la catégorie du nom propre à l'aide du moteur 1
                    end
                when "when" :
                    np = get_np
# on récupère la catégorie de l'entité nommée, sinon cat = "unk"                    
                else cat = "unk"
            end
        end
    end
    
    def categorize_e3
    end

    def extract_e1
        kw_array = get_np
        if !get_np.include?(@sent.object)
            kw_array.push(@sent.object) unless @sent.object.nil? 
            @sent.linkages.first.links.each do |l|
                kw_array.push(l.lword) if (l.rword.split(".").first == @sent.object) && (l.label =~ /A.*/)
            end
        end
        kw_str = "" 
        kw_array.each { |w| kw_str += "#{w.split(".").first} " }
        kw_str.strip!
        kw_str
    end

    def extract_e1_2
# Deuxième version à tester, appel de la fonction récursive ctree_rec
        
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
    end
end
