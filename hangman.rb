require 'set'

class Hangman
  
  attr_reader :guesser, :referee
  attr_accessor :partial_word, :guess, :wrong_guesses
  
  def initialize(player1, player2)
    @guesser = player1
    @referee = player2
    @wrong_guesses = 0
    @partial_word = '*'
  end
  
  def play
    
    length = referee.pick_secret_word.to_i
    @partial_word = '*' * length
    
    guesser.receive_secret_length(length)
    
    until won?
      @guess = guesser.guess(wrong_guesses)
    
      correct_places = referee.check_guess(guess)
      correct = correct_places.empty? ? false : true
      
      update_word(correct_places)
      
      guesser.handle_response(@partial_word, @guess, correct)
    end
    
    if winner == :referee
      puts "Referee wins!"
    else
      puts "Guesser wins! Is this your word? #{@partial_word} ;)"
    end
    
    # puts "Play again? (y/n)"
    # input = gets.chomp.downcase
    #
    # if input == 'y'
    #   @wrong_guesses = 0
    #   @partial_word = '*'
    #   guess = nil
    #
    #   play
    # end
  end
  
  private
  
  def won?
    return true if !@partial_word.chars.include?('*')
    return true if wrong_guesses >= 7
    
    false
  end
  
  def winner
    :referee if wrong_guesses >= 7
  end
  
  def update_word(indices)
    @wrong_guesses += 1 if indices.empty?
    
    indices.each { |i| @partial_word[i] = @guess }
  end
end

class ComputerPlayer
  
  attr_reader :guessed_letters
  
  def initialize
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
    @guessed_letters = []
  end
  
  # <--REF METHODS--> 
  
  def pick_secret_word
    @secret_word = dictionary.sample
    @secret_word.length
  end
  
  def check_guess(guess)
    correct_positions = []
    
    @secret_word.chars.each_with_index do |char, i|
      correct_positions << i if char == guess
    end
    
    correct_positions
  end
  
  # <--GUESSER METHODS-->
  
  def receive_secret_length(length)
    trimmed_words = @dictionary.select { |word| word.length == length }
    @trimmed_dictionary = Set.new(trimmed_words)
  end
  
  def guess(ignore)
    most_common_letters = ['e', 't', 'a', 'o', 'i', 'n', 's', 'h', 'r', 'd', 'l', 'c', 'u', 'm', 'w', 'f', 'g', 'y', 'p', 'b', 'v', 'k', 'j', 'x', 'q', 'z']
  
    if @trimmed_dictionary.count < 1000
      guess = make_smart_guess
    else
      guess = most_common_letters.find { |letter| !@guessed_letters.include?(letter)}
    end
    
    @guessed_letters << guess
    
    guess
  end
  
  def handle_response(partial_word, guess, correct)
    if correct
      cut_dictionary_when_right(partial_word)
    else
      cut_dictionary_when_wrong(guess)
    end
  end
  
  private 
  
  attr_accessor :dictionary, :trimmed_dictionary, :secret_word
  
  def cut_dictionary_when_right(partial_word)
    # checks all non-asterisk chars against the partial word
    # removes non-matching words from the dictionary
    @trimmed_dictionary.select! do |word|
      
      match = true
      partial_word.chars.each_with_index do |char, i|
        next if char == '*'
        match = false unless char == word[i]
      end
      
      match
    end
  end
  
  def cut_dictionary_when_wrong(guess)
    # removes all words that contain the incorrect guess
    @trimmed_dictionary.select! { |word| !word.include? guess }
  end
  
  def make_smart_guess
    # guesses the letter most-represented among the words left 
    dict_chars = @trimmed_dictionary.to_a.join('').split('')
    dict_chars.select! { |char| !@guessed_letters.include?(char) }
    
    guess = dict_chars.max_by { |char| dict_chars.count(char) }
    
    guess
  end
  
end

class HumanPlayer
  
  attr_reader :guessed_letters
  
  def initialize
    @guessed_letters = []
  end
  
  # <--REF METHODS--> 
  
  def pick_secret_word
    puts "Think carefully of a word and input its length."
    
    gets.chomp
  end
  
  def check_guess(guess)
    puts "Here's our best guess: #{guess}."
    puts "Tell us where we got it right. Write the positions of the letter, separated by commas."
    puts "If our guess is dead wrong, just hit enter."
    
    response = gets.chomp
    
    return [] if response.nil?
    
    response.split(',').map { |char| char.strip.to_i - 1 }
  end
  
  # <--GUESSER METHODS-->
  
  def receive_secret_length(length)
    puts "Our word is #{length} letters long. Bet you can't guess it!"
  end
  
  def guess(wrong_guesses)
    puts "#{7 - wrong_guesses} guesses remaining!"
    
    puts "What is your guess?"
    guess = gets.chomp.downcase
    
    if @guessed_letters.include? (guess)
      puts "You already guessed that! Try again."
      guess(wrong_guesses)
    end
    
    @guessed_letters << guess
    
    guess
  end
  
  def handle_response(partial_word, guess, correct)
    correct_phrase = correct ? "You were right" : "Sucker! No luck this time"
    
    puts "You guessed #{guess}. #{correct_phrase}! Here's the word now:"
    puts partial_word
  end
end