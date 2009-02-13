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
Amount_Cat = []
Place_Cat  = ["topographic point", "place", "spot", "location", "space"]
Pers_Cat   = []
Prod_Cat   = []
Date_Cat   = []
Time_Cat   = []
Org_Cat    = []

             

class String

    def categorize(hypernym = nil)
        cat = nil
        hypernym = synset(self) if hypernym.nil?
        nb = 0 if nb.nil?
        hypernym.synonyms.each do |s|
            cat = "place"   if Place_Cat.include?(s)
            cat = "pers"    if Pers_Cat.include?(s)
            cat = "prod"    if Prod_Cat.include?(s)
            cat = "org"     if Org_Cat.include?(s)
            cat = "time"    if Time_Cat.include?(s)
            cat = "date"    if Date_Cat.include?(s)
            cat = "amount"  if Amount_Cat.include?(s)
        end

        if cat.nil?
            hypernym.hypernyms.each { |h| cat = self.categorize(h) }
        end
        cat
    end

    def categorize_np
# interraction avec le premier moteur pour récupérer la catégorie
# d'un nom propre
    end

end
