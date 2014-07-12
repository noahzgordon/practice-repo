require 'set'

class WordChainer
  
  attr_reader :dictionary, :trimmed_dictionary
  
  def initialize
    @dictionary = Set.new(File.readlines('dictionary.txt').map(&:chomp))
  end
  
  def adjacent_words(word)
    trimmed = dictionary.select do |dict_word| 
      match_count = 0
      dict_word.chars.each_with_index do |char, i|
        match_count += 1 if char == word[i]
      end
      dict_word.length == word.length && match_count == word.length - 1
    end
    
    @trimmed_dictionary = Set.new(trimmed)
  end
end