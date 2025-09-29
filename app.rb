require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions # to support sessions to preserve game object across http requests
  register Sinatra::Flash # helps us preserve message to next requests (e.g. here is /show)

  set :host_authorization, { permitted_hosts: [] }  

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do # start of the /guess routes (aka controller)
    letter = params[:guess].to_s[0]
    
    begin
      new_guess = @game.guess(letter) # true if accepted; false if already used
      flash[:message] = "You have already used that letter" unless new_guess
    rescue ArgumentError
      flash[:message] = "Invalid guess"
    end

    redirect '/show'

  end # end of the /guess routes (aka controller)

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do # start of the /show route (aka controller)
    
    
    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    else
      erb :show
    end # end of case expression

  end # start of the /show route (aka controller)

  get '/win' do # start of the /win route (aka controller)
    erb :win # directly present views/win.erb (a given webpage)
  end # end of the /win route (aka controller)

  get '/lose' do # start of the /lose route (aka controller)
    erb :lose # directly present views/lose.erb (a given webpage)
  end # end of the /lose route (aka controller)

end


