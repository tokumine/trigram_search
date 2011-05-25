require '../src/trigram_search'

# benchmark
n = 1000
search_db = TrigramSearch.new "test_data.csv", 2

puts "benchmarking n=#{n}"
Benchmark.bm do |x|
  x.report { for i in 1..n; search_db.search("madrid"); end }  
end     
