require '../src/trigram_search'

# demonstration
search_db = TrigramSearch.new "test_data.csv", 2
pp search_db.search("Madrid", 4)

# # benchmark
# n = 100
# Benchmark.bm do |x|
#   x.report("search: ") { for i in 1..n; search_db.search("madrid"); end }  
# end     
