# # # # # # # # #
# Classe String #
# # # # # # # # #
#
# Functions : categorize, categorize_np, check_np, categorize_ccg
#
# Synopsis : les fonctions définies ici sont liés à la catégorisation
# sémantique d'un mot.
#
# Authors : Romain Deveaud, Ludovic Bonnefoy
#
# NLGbAse.QR, May 2009
#
# # # # #

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
Loc_Cat    = ["topographic point", "place", "spot", "location", "space","city","country","continent"]
Fonc_Cat = ["leader", "representative"]
Fonc_Rel_Cat = ["spiritual leader", "religious leader", "scoutmaster"]
Fonc_Ari_Cat = ["aristocrat", "blue blood", "patrician"]
Fonc_Mil_Cat = ["military leader", "strike leader"]
Fonc_Pol_Cat = ["nationalist leader", "politician", "politico", "pol", "political leader", "puppet ruler", "puppet leader", "assemblyman", "assemblywoman", "head of state", "chief of state"]
Fonc_Admi_Cat = ["civic leader", "civil leader", "delegate", "administrator", "executive", "secretary"]
Prod_Vehicle_Cat = ["conveyance", "transport"]
Prod_Award_Cat = ["award", "accolade", "honor", "honour", "laurels" , "prize"]
Pers_Cat   = []
Prod_Cat   = ["product","production","ware"]
Date_Cat   = ["day","month","year","century","time"]
Time_Cat   = []
Time_Hour_Cat   = []
Org_Cat    = ["company", "organization"]
Org_Pol_Cat    = ["government officials", "officialdom", "city council", "executive council", "works council", "polity", "union", "labor union", "trade union", "trades union", "brotherhood", "party", "political party", "political machine"]
Org_Edu_Cat    = ["educational institution", "academy", "honorary society"]
Org_Com_Cat    = ["management", "financial institution", "financial organization", "financial organisation", "company", "enterprise"]
Org_Non_Profit_Cat    = ["Curia", "medical institution", "charity", "organized religion", "vicariate", "vicarship", "nongovernmental organization", "NGO"]
Org_Div_Cat    = ["musical organization", "musical organisation", "musical group", "museum", "company", "troupe", "team", "broadcasting station", "broadcast station","band","rock band","musical band","group","museum"]
Org_GSP_Cat    = ["aministrative district", "administrative division", "territorial division"]
Unk = ["animal"]
             

class String

    def categorize(hypernym = nil)

# Cette fonction utilise les synsets de WordNet afin de pouvoir remonter
# la hiérarchie hyperonimique d'un mot et ainsi pouvoir le catégoriser
# à partir des mots "généraux" présents dans les tableaux ci-dessus.

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

# La récursivité se lance ici.        

        hypernym.hypernyms.each { |h| cat = self.categorize(h) } if cat.nil?


# Si aucune catégorie n'a été détectée par WordNet, nous allons chercher
# directement dans NLGbAse la classe du document correspondant au mot
# recherché.

        if cat.nil? && hypernym == synset(self)
            cat = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/lr_info_extractor.pl?query=#{self}&search=EN")).split(":")[0]
            cat = nil if (cat == "" or cat.nil?)
            return cat if !cat.nil?
            cat = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/lr_info_extractor.pl?query=#{self}&search=EN")).split(":")[1]
            cat = nil if (cat == "" or cat.nil?)
            return cat if !cat.nil?

# L'information lexicale fournie par WordNet est peu fiable, c'est pourquoi
# elle est utilisée en dernier recours si rien n'a été trouvé précédemment.

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

    def cat_from_nlgbase

# Interraction avec NLGbAse pour récupérer la catégorie d'un nom propre.

      arr = Net::HTTP.get(URI.parse("http://www.nlgbase.org/perl/lr_info_extractor.pl?query=#{self}&search=EN")).split(":")
      cat = arr[0]
      cat = arr[1] if arr[0] == ""

      cat
    end

    def categorize_np

        cat = self.cat_from_nlgbase

# Si rien n'a été trouvé, il est fort probable que le nom propre ait été
# mal orthographié, une vérification auprès de Google (check_np) est 
# effectuée, et une requête est de nouveau effectuée.

        if cat.nil? 
            temp = self.check_np
            cat = temp.cat_from_nlgbase if temp != ""
        end

        cat
   end

   def check_np

# Recherche auprès de GoogleSuggest pour corriger l'orthographe d'un
# nom propre.

        arr2 = Net::HTTP.get(URI.parse("http://www.google.com/search?hl=en&q=#{self}&btnG=Search")).split("Did you mean:")
        temp = ""
        if(!arr2[1].nil?)
            arr2 = arr2[1].split("</a>")
            arr2 = arr2[0].split("class=p>")
            arr2 = arr2[1].split(/\<\/?[a-z0-9]\>+/)

            temp = arr2.join(" ").split.join("+")
        end
        temp
    end

    def categorize_ccg
        res = Net::HTTP.post_form(URI.parse('http://l2r.cs.uiuc.edu/cgi-bin/LbjNer-front.pl'),{'dest'=>'NETagger', 'sentence'=>self, '.cgifields'=>'dest'})
        res = res.body.split("[")
        res = res[1].split if !res[1].nil?

        cat = case res[0]
            when "PER" : "pers"
            when "LOC" : "loc"
            when "ORG" : "org"
            #when "MISC" : "pouet"
            else "unk"
        end

        cat

    end
 
end
