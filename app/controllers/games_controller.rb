class GamesController < ApplicationController
  def new
    @grid = 10.times.map { ('a'..'z').to_a.sample }
    @start_time = Time.now
  end

  def score
    @word = params[:word]
    grid = params[:grid]
    start_time = params[:start_time].to_time
    end_time = Time.now
    @result = run_game(@word, grid, start_time, end_time)
  end

  private

  def api(attempt)
    api_url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    serialized_attempt = RestClient.get(api_url)
    JSON.parse(serialized_attempt)
  end

  def contains_attempt?(attempt, grid)
    attempt.split("").all? { |letter| grid.include? letter }
  end

  # def contains_attempt?(attempt, grid)
  #   attempt_characters = attempt.upcase.chars
  #   attempt_characters.all? { |letter| attempt_characters.count(letter) <= grid.count(letter) }
  # end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    # check if attempt is inside grid & it's an english word
    result = { score: 0 }
    if contains_attempt?(attempt, grid) == false
      result[:message] = 'not in the grid'
    elsif
      !api(attempt)['found'] # not an English word
      result[:message] = 'not an english word'
      # is an English, but not in the grid
    else
      result[:time] = end_time - start_time
      result[:message] = 'well done'
      result[:score] = attempt.length * 1.25 + 100 - (end_time - start_time).to_i
    end
    result
  end
end
