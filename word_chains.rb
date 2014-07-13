require 'set'

class WordChainer
  
  #attr_reader and _writer not working for some reason
  attr_reader :dictionary, :current_words, :all_seen_words
  attr_writer :current_words, :all_seen_words
  
  def initialize
    @dictionary = Set.new(File.readlines('dictionary.txt').map(&:chomp))
  end
  
  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source => nil }
    
    explore_current_words
    
    path = build_path(target)
    
    if path.count == 1
      puts "No path exists."
    else
      path.each { |word| puts word }
    end
  end

  private  
  
  def explore_current_words
    until @current_words.empty?
      new_current_words = []
      
      @current_words.each do |cur_word|
        
        adjacent_words(cur_word).each do |adj_word|
          next if @all_seen_words.include? adj_word
          
          new_current_words << adj_word
          @all_seen_words[adj_word] = cur_word
        end
      end
      
      @current_words = new_current_words
    end
  end
  
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
  
  def build_path(target)
    return [] if target.nil?
    
    build_path(@all_seen_words[target]) << target
  end
end