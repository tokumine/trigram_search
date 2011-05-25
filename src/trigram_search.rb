# encoding: UTF-8

# Trigram substring inverted search index.
#
# This demo creates a search db from a CSV and allows searching on it
# 
# could be used for high speed text matching, such as in autocompletes
# 
# ref: http://en.wikipedia.org/wiki/Inverted_index
#      http://en.wikipedia.org/wiki/Substring_index
#

require 'fileutils'
require 'csv'
require 'set'
require 'pp'
require 'benchmark'

class TrigramSearch  
  attr_reader :search_db, :trigrams  
  
  # Create search index from a CSV. 
  #
  # @params filename is a CSV file of the data you want to search
  # @params i is the column index of the data you want to search on in the CSV
  def initialize(filename, i)  

    
    @search_db = []
    @trigrams = {}

    # take index source strings from CSV in column i as search db"
    CSV.foreach(filename, {:encoding=> 'UTF-8'}) do |row|
      @search_db << row[i].downcase.encode("UTF-8")
    end

    # generate trigram inverted index
    @search_db.each_with_index do |m, i|
      tgrams = m.to_trigrams.to_a  
      tgrams.each do |tg|    
        if @trigrams[tg]
          @trigrams[tg] << i 
        else
          @trigrams[tg] = [i]
        end  
      end  
    end  
  end  

  # Search the generated index
  # @param term is the search term
  # @param result_num is the number of matching results you want 
  def search(term, result_num=4)
    search_grams = term.to_trigrams

    # grab all search index ids where the grams exist
    gram_match = search_grams.inject([]) { |acc, gram| acc << @trigrams[gram] } 
    gram_match.flatten!.compact!

    # rank and sort matching ids
    match_counts   = gram_match.inject(Hash.new(0)) { |acc, v| acc[v] += 1; acc; }
    ranked_results = match_counts.sort { |y, x| x[1]<=>y[1] }

    # return number of results requested by user
    ranked_results[0..result_num-1].map{|x| @search_db[x[0]]}
  end  
end  

# yes, I know, never monkey patch core classes
class String
  
  # you could make bigrams by changing 3 => 2 here
  def to_trigrams
    trigrams = Set.new    
    self.clean_up.split.each do |p|
        word = "  " + p.downcase + "  "
        (0..word.length - 3).each do |idx|
            trigrams.add(word[idx, 3])
        end
    end
    trigrams
  end
  
  def clean_up
    self.gsub(/(\s|\(|\)|\-|\.|\/|\'|\,)+/, "")
  end  
end
