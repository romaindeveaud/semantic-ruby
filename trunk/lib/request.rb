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

    def categorize_e1
    end
    
    def categorize_e2
    end

    def extract_e1
    end
    
    def extract_e2
    end
    
    def extract_e3
    end
end
