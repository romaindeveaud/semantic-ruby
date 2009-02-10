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

# Les deux fonctions ci-dessous vont analyser la requête pour choisir
# le moteur qui convient le mieux, puis elles appeleront les fonctions
# privées suivant le résultat.
    def categorize
    end

    def extract
        print "Keywords selected for engine 1 : "
        extract_e1
    end

private
    def categorize_e1
    end
    
    def categorize_e2
    end

    def extract_e1
        kw_array = get_np
        if !get_np.include?(@sent.object)
            kw_array.push(@sent.object)
            @sent.linkages.first.links.each do |l|
                kw_array.push(l.lword) if (l.rword.split(".").first == @sent.object) && (l.label =~ /A.*/)
            end
        end
        kw_str = "" 
        kw_array.each { |w| kw_str += "#{w.split(".").first} " }
        kw_str.strip
        kw_str
    end
    
    def extract_e2
    end
    
    def extract_e3
    end
end
