require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    # The word can’t be built out of the original grid
    # The word is valid according to the grid, but is not a valid English word
    # The word is valid according to the grid and is an English word
    if included?(params[:word].upcase, params[:letters]) && english_word?(params[:word])
      @message = "Congratulations! #{params[:word].upcase} is a valid English word"
    elsif included?(params[:word].upcase, params[:letters]) && !english_word?(params[:word])
      @message = "Sorry but #{params[:word].upcase} is not an English word"
    else
      @message = "Sorry but #{params[:word].upcase} cannot be built out of #{params[:letters]}"
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
