class Hangman
  
  attr_reader :guesser, :referee
  
  def initialize(player1, player2)
    @guesser = player1
    @referee = player2
    @wrong_guesses = 0
  end
  
  def play
    length = referee.pick_secret_word
    partial_word = '*' * length
    
    guesser.receive_secret_length(length)
    
    until won?
      guess = guesser.guess
    
      correct_places = referee.check_guess(guess)
      
      update_word(correct_places)
      
      guesser.handle_response(partial_word)
    end
    
    if winner == guesser
      puts "Guesser wins! He/she/ze got the word #{partial_word}."
    else
      puts "Referee wins! The Guesser couldn't get the word #{partial_word}."
    end
    
    puts "Play again? (y/n)"
    input = gets.chomp.downcase
    
    if input == 'y'
      wrong_guesses = 0
      partial_word = nil
      guess = nil
      
      play
    end
  end
  
  private
  
  attr_accessor :partial_word, :guess, :wrong_guesses
  
  def won?
    return true unless partial_word.chars.include?('*')
    return true if wrong_guesses >= 7
    
    false
  end
  
  def winner
    guesser unless partial_word.chars.include?('*')
    referee if wrong_guesses >= 7
  end
  
  def update_word(indices)
    wrong_guesses += 1 if indices.empty?
    
    indices.each { |i| partial_word[i] = guess }
  end
end

class ComputerPlayer
  
  def initialize
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
  end
  
  # <--REF METHODS--> 
  
  def pick_secret_word
    
  end
  
  def check_guess
    
  end
  
  # <--GUESSER METHODS-->
  
  def receive_secret_length
    
  end
  
  def guess
    
  end
  
  def handle_response
    
  end
end

class HumanPlayer
  
  def initialize
    
  end
  
  # <--REF METHODS--> 
  
  def pick_secret_word
    
  end
  
  def check_guess
    
  end
  
  # <--GUESSER METHODS-->
  
  def receive_secret_length
    
  end
  
  def guess
    
  end
  
  def handle_response
    
  end
end