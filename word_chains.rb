require 'set'

class WordChainer
  
  attr_reader :dictionary
  attr_accessor :current_words, :all_seen_words
  
  def initialize
    @dictionary = Set.new(File.readlines('dictionary.txt').map(&:chomp))
  end
  
  def run(source, target)
    current_words = [source]
    all_seen_words = [source]
    
  end
  
  private
  
  def adjacent_words(word)
    adj_words = []
    
    word.chars.each_with_index do |char, i|
      ('a'..'z').to_a.each do |alph|
        new_word = word.dup
        
        new_word[i] = alph unless word[i] == alph
        adj_words << new_word if dictionary.include? new_word
      end
    end
    
    adj_words
  end
  
  def explore_current_words
    until current_words.empty?
      new_current_words = []
      
      current_words.each do |cur_word|
        
        adjacent_words(cur_word).each do |adj_word|
          next if all_seen_words.include? adj_word
          
          new_current_words << adj_word
          all_seen_words << adj_word
        end
      end
      
      p new_current_words
      current_words = new_current_words
    end
  end
 
end