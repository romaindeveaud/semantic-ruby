class Request
    attr_reader :sent

    def initialize(request)
        @sent = sentence(request)
    end

    def diagram
        @sent.diagram
    end

    def get_np
    end

# Les deux fonctions ci-dessous vont analyser la requête pour choisir
# le moteur qui convient le mieux, puis elles appeleront les fonctions
# privées suivant le résultat.
    def categorize
    end

    def extract
        extract_e1
    end

private
    def categorize_e1
    end
    
    def categorize_e2
    end

    def extract_e1
        np = Array.new
        @sent.linkages.first.links.each { |l| np.push(l.lword, l.rword) if l.label == "G" }
        np.uniq!
        proper_noun = ""
        np.each { |w| proper_noun += "#{w.split(".").first} " }
        proper_noun.strip
        proper_noun
    end
    
    def extract_e2
    end
    
    def extract_e3
    end
end
