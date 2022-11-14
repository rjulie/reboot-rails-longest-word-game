require 'open-uri'

# Games Controller
class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y]

  def new
    # grid = []
    # 10.times do
    #   grid << ('A'..'Z').to_a.sample
    # end
    # @letters = grid

    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    # raise
    @game = 0
    @letters = params[:letters].split
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    @score = game(@word)
  end

  private

  def game(word)
    score = word.length**2
    @game += score
  end

  def included?(word, letters)
    # pour chacune des lettres de @word, existe-t-il au moins 1 fois cette lettre dans @letters ?
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    # { "found": true, "word": "rice", "length": 4}
    word['found']
  end

end
