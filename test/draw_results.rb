require 'scruffy'

cat_point_markers = []
cat_precision_bar = []
cat_recall_bar    = []
keywords_bar      = []
keywords_point_markers = []
File.new("datas_categorizing").readlines.each do |l|
  l = l.chomp.split
  cat_point_markers.push("#{l[0]}")
  cat_precision_bar.push(l[1].to_f, 0, 0)
  cat_recall_bar.push(0, l[2].to_f, 0)
end

File.new("datas_extracting").readlines.each do |l|
  l = l.chomp.split
  l[0] = case l[0]
    when "kw_e1_e2" : "Engine 1 & 2"
    when "en_e3"    : "Named Entity"
    when "kw_e3"    : "Engine 3"
  end
  keywords_point_markers.push(l[0])
  keywords_bar.push(l[1].to_f, 0)
end

keywords_point_markers.push(" ")

graph = Scruffy::Graph.new(:title => "Categorization evaluation", :value_formatter => Scruffy::Formatters::Number.new(:precision => :auto))
graph.renderer = Scruffy::Renderers::Standard.new

graph.add :bar, "Precision", cat_precision_bar
graph.add :bar, "Recall", cat_recall_bar
graph.point_markers = cat_point_markers
graph.render  :min_value => 0, :max_value => 1, :to => "cat_results.png", :as => "png"

graph = Scruffy::Graph.new(:title => "Keywords extraction evaluation", :value_formatter => Scruffy::Formatters::Number.new(:precision => :auto))
graph.renderer = Scruffy::Renderers::Standard.new

graph.add :bar, "Precision", keywords_bar
graph.point_markers = keywords_point_markers
graph.render  :min_value => 0, :max_value => 1, :to => "keywords_results.png", :as => "png"
