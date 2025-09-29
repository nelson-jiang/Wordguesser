class WordGuesserGame # the start of class definition
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  
  attr_accessor  :word, :guesses, :wrong_guesses # getters and setters
  def initialize(word) # start of constructor definition

    @word = word # set the attribute `word` to be the argument word
                   # this was given to me already

    @guesses = '' # a "bucket" to hold good guesses
    @wrong_guesses = '' # a "bucket" to hold wrong guesses

  end # end of constructor definition

  

  def guess(guessed_char) # start of guess method defn.
      
      # validating guessed_char
      raise ArgumentError if guessed_char.nil? # nil guess
      raise ArgumentError if guessed_char.empty? # empty guess
      raise ArgumentError unless guessed_char.match?(/\A[a-z]\z/i) # non-letter guess
      
      guessed_char = guessed_char.downcase # normalize to downcase to disregard capitalization
      
      return false if @guesses.include?(guessed_char) || @wrong_guesses.include?(guessed_char) # we don't want to guess already guessed letters


      # checking 
      if @word.downcase.include?(guessed_char)
        @guesses << guessed_char # @ is referring to the attributes
                                   # appending the guessed_char onto guesses
      else
        @wrong_guesses << guessed_char
      end

      return true # return true when the guess hasn't been used before

  end # end of guess method defn.

  def word_with_guesses() # start of word_with_guesses method defn

    "
     this method renders the secret word
     revealing the correctly guessed letters and putting -- in the unguessed/incorrect slots
    "

    guessed = @guesses.downcase

    return @word.each_char.map{|word_char| @guesses.include?(word_char.downcase) ? word_char : '-' }.join  # .each_char will Enumerator through the characters of `word`
                                       # .map{...} will transform each enumerated character into what you want to show
                                           # if the condition is true (the condition is left of the ?)
                                              # then return left of the :
                                           # else return right of the :
                                       # .join will concatenate array into a single string

  
  end #end of word_with_guesses method defn


  def check_win_or_lose() # start of check_win_or_lose method defn.
     
    word_letters = @word.downcase.chars
    good_letters = @guesses.downcase.chars

    return :win if (word_letters - good_letters).empty? # all the good letters match the secret letters --> user wins

    return :lose if @wrong_guesses.length >= 7  # wrong guesses exceeded 7 --> user loses

    return :play  # continue playing

  end  #end of check_win_or_lose method defn.
  

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word # start of get random word member function defn.
                             # this is a SaaS service call
                             # this is already given 
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord') # SaaS service call
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end #end of get random word member function defn.



end # the end of class definition
