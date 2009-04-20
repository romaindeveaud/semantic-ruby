require 'net/http'

# Ruby propose des classes ouvertes. Ici j'ai besoin de rajouter une méthode
# à la classe String (je ne pouvais pas la mettre dans la classe Request, ça
# n'aurait pas été pertinent par rapport à sa sémantique), je vais donc 
# l'ouvrir et définir ma méthode comme je l'aurai fais avec une nouvelle
# classe, à ceci près que la classe String va avoir une méthode en plus.
# Bien sûr, tout ceci est transparent à l'utilisation.
#
# # # # #

# # # # # # # #
# Constantes  #
# # # # # # # #

# Début d'étiquettage des mots proposés par WordNet.
#
# A noter, l'hyperonyme de l'hyperonyme de 'place', c'est 'location', et après
# c'est 'object'. On pourrait donc attribuer automatique la catégorie place
#  si on arrive à remonter à 'location'.
#
Amount_Cat = []
Amount_Phy_Temp_Cat = ["temperature", "temperature unit"]
Amount_Phy_Age_Cat = ["age"]
Amount_Phy_Spd_Cat = ["megaflop", "MFLOP", "million floating point operations per second", "teraflop", "trillion floating point operations per second", "MIPS", "million instructions per second", "speed", "velocity"]
Amount_Phy_Wei_Cat = ["mass", "mass unit", "weight", "weight unit"]
Amount_Phy_Len_Cat = ["length", "linear unit", "linear measure"]
Amount_Phy_Area_Cat = ["area unit", "square measure"]
Amount_Phy_Vol_Cat = ["volume unit", "capacity unit", "capacity measure", "cubage unit", "cubic measure", "cubic content unit", "displacement unit", "cubature unit"]
Amount_Phy_Cur_Cat = ["monetary unit"]
Loc_Cat    = ["topographic point", "place", "spot", "location", "space"]
Fonc_Cat = ["leader", "representative"]
Fonc_Rel_Cat = ["spiritual leader", "religious leader", "scoutmaster"]
Fonc_Ari_Cat = ["aristocrat", "blue blood", "patrician"]
Fonc_Mil_Cat = ["military leader", "strike leader"]
Fonc_Pol_Cat = ["nationalist leader", "politician", "politico", "pol", "political leader", "puppet ruler", "puppet leader", "assemblyman", "assemblywoman", "head of state", "chief of state"]
Fonc_Admi_Cat = ["civic leader", "civil leader", "delegate", "administrator", "executive", "secretary"]
Prod_Vehicle_Cat = ["conveyance", "transport"]
Prod_Award_Cat = ["award", "accolade", "honor", "honour", "laurels" , "prize"]
Pers_Cat   = ["name"]
Prod_Cat   = ["product","production","ware"]
Date_Cat   = ["day","month","year","century","time"]
Time_Cat   = []
Time_Hour_Cat   = []
Org_Cat    = []
Org_Pol_Cat    = ["government officials", "officialdom", "city council", "executive council", "works council", "polity", "union", "labor union", "trade union", "trades union", "brotherhood", "party", "political party", "political machine"]
Org_Edu_Cat    = ["educational institution", "academy", "honorary society"]
Org_Com_Cat    = ["management", "financial institution", "financial organization", "financial organisation", "company", "enterprise"]
Org_Non_Profit_Cat    = ["Curia", "medical institution", "charity", "organized religion", "vicariate", "vicarship", "nongovernmental organization", "NGO"]
Org_Div_Cat    = ["musical organization", "musical organisation", "musical group", "museum", "company", "troupe", "team", "broadcasting station", "broadcast station"]
Org_GSP_Cat    = ["aministrative district", "administrative division", "territorial division"]
Unk = ["animal"]
             

class String

    def categorize(hypernym = nil)
        cat = nil

#        if hypernym.nil?
#            cat = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/lr_info_extractor.pl?query=#{self}&search=EN")).split(":")[0]
#            cat = nil if (cat == "" or cat.nil?)
#            return cat if !cat.nil?
#        end

        hypernym = synset(self) if hypernym.nil?
        return "unk" if hypernym.nil?

        hypernym.synonyms.each do |s|
            cat = "amount"            if Amount_Cat.include?(s)
            cat = "amount.phy.age"    if Amount_Phy_Age_Cat.include?(s)
            cat = "amount.phy.vol"    if Amount_Phy_Vol_Cat.include?(s)
            cat = "amount.phy.cur"    if Amount_Phy_Cur_Cat.include?(s)
            cat = "amount.phy.spd"    if Amount_Phy_Spd_Cat.include?(s)
            cat = "amount.phy.area"   if Amount_Phy_Area_Cat.include?(s)
            cat = "amount.phy.temp"   if Amount_Phy_Temp_Cat.include?(s)
            cat = "amount.phy.wei"    if Amount_Phy_Wei_Cat.include?(s)
            cat = "amount.phy.len"    if Amount_Phy_Len_Cat.include?(s)
            cat = "loc"               if Loc_Cat.include?(s)
            cat = "pers"              if Pers_Cat.include?(s)
            cat = "prod"              if Prod_Cat.include?(s)
            cat = "prod.vehicle"      if Prod_Vehicle_Cat.include?(s)
            cat = "prod.award"        if Prod_Award_Cat.include?(s)
            cat = "org"               if Org_Cat.include?(s)
            cat = "org.pol"           if Org_Pol_Cat.include?(s)
            cat = "org.edu"           if Org_Edu_Cat.include?(s)
            cat = "org.div"           if Org_Div_Cat.include?(s)
            cat = "org.com"           if Org_Com_Cat.include?(s)
            cat = "org.non-protif"    if Org_Non_Profit_Cat.include?(s)
            cat = "org.gsp"           if Org_GSP_Cat.include?(s)
            cat = "time"              if Time_Cat.include?(s)
            cat = "time.hour"         if Time_Hour_Cat.include?(s)
            cat = "date"              if Date_Cat.include?(s)
            cat = "fonc"              if Fonc_Cat.include?(s)
            cat = "fonc.rel"          if Fonc_Rel_Cat.include?(s)
            cat = "fonc.ari"          if Fonc_Ari_Cat.include?(s)
            cat = "fonc.mil"          if Fonc_Mil_Cat.include?(s)
            cat = "fonc.pol"          if Fonc_Pol_Cat.include?(s)
            cat = "fonc.admi"         if Fonc_Admi_Cat.include?(s)
        end

        hypernym.hypernyms.each { |h| cat = self.categorize(h) } if cat.nil?

        if cat.nil? && hypernym == synset(self)
            cat = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/lr_info_extractor.pl?query=#{self}&search=EN")).split(":")[0]
            cat = nil if (cat == "" or cat.nil?)
            return cat if !cat.nil?
            cat = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/lr_info_extractor.pl?query=#{self}&search=EN")).split(":")[1]
            cat = nil if (cat == "" or cat.nil?)
            return cat if !cat.nil?
            cat = case hypernym.lex_info.split(".").last
                when "person"   : "pers.hum"
                when "artifact" : "prod"
                when "location" : "loc"
                when "group"    : "org"
                when "animal"   : "pers.anim"
                else "unk"
            end
        end
        cat
    end

    def categorize_np
# interraction avec le premier moteur pour récupérer la catégorie
# d'un nom propre
        arr = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/lr_info_extractor.pl?query=#{self}&search=EN")).split(":")
        cat = arr[0]
        cat = arr[1] if arr[0] == ""

        if cat.nil?
            arr2 = Net::HTTP.get(URI.parse("http://www.google.com/search?hl=en&q=#{self}&btnG=Search")).split("Did you mean:")
            if(!arr2[1].nil?)
                arr2 = arr2[1].split("</a>")
                arr2 = arr2[0].split("class=p>")
                arr2 = arr2[1].split(/\<\/?[a-z0-9]\>+/)

                temp = arr2[0].to_s.chomp(" ")+"+"+arr2[2].to_s

                arr = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/lr_info_extractor.pl?query="+temp.to_s+"&search=EN")).split(":")
                cat = arr[0]
                cat = arr[1] if arr[0] == ""
            end

        end

        cat
    end

end
