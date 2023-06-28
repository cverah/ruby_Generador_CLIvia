require "httparty"
require "json"
require "htmlentities"
require "terminal-table"
require "colorize"

require_relative "presenters/presenters"
require_relative "requests/requesters"
require_relative "bug-grabber/errno"
require_relative "validations/validations"

class CliviaGenerator
  attr_reader :score

  include Presenterable
  include Requesterable
  include Validationable
  include HTTParty

  base_uri("https://opentdb.com")

  def initialize
    @questions = {}
    @score = 0
    # capture command line arguments (ARGV)
    validation_extension_json
    if File.empty?(@filename)
      @data_score = []
      # capturar el error
      raise Errno::Enoent
    else
      @data_score = JSON.parse(File.read(@filename), symbolize_names: true)
    end
  rescue Errno::Enoent, JSON::ParserError => e
    e.message
  end

  def start
    @score = 0
    print_welcome
    # solicitar al usuario una acción
    select_main_menu_action
  end

  def random_trivia
    # llamar a la instancia de clase es como llamar CliviaGenerator.get
    # cargas datos de API
    response = self.class.get("/api.php?amount=10")
    @questions = JSON.parse(response.body, symbolize_names: true)
    @score = load_questions
    will_save?(@score)
  end

  def ask_questions(response_number, all_options, correct_answer)
    # array in position -1 because the array starts at 0
    # print the solution of askwers
    response_number -= 1
    if all_options[response_number] == correct_answer
      puts "#{all_options[response_number]}...Correct!"
      @score += 10
    else
      puts "#{all_options[response_number]}...Incorrect!"
      puts "The correct answer was: #{correct_answer}"
    end
    @score
  end

  def save(data)
    # write to file the scores data
    @data_score << data
    File.write(@filename, JSON.pretty_generate(@data_score))
    start
  end

  def parse_scores
    # print table score
    table = Terminal::Table.new
    table.title = "Top Scores".colorize(:blue)
    table.headings = ["Name", "Scores"]
    table.rows = print_scores
    puts table
    start
  end

  def load_questions
    question_number = 1
    @questions[:results].each do |question|
      # formato a pregunta en request.rb
      puts "\nQuestion Number Nro: #{question_number}"
      @score = ask_question(question)
      question_number += 1
    end
    @score
  end

  def parse_questions(question)
    # decode ANSI string and array
    coder = HTMLEntities.new
    return coder.decode(question) if question.instance_of?(String)
    return question.map { |data| coder.decode(data) } if question.instance_of?(Array)
  end

  def print_scores
    # order data by score in ascending and at the end apply reverse
    data_desc = @data_score.sort_by { |data| data[:score] }.reverse
    data_desc.map { |data| [data[:name], data[:score]] }
  end
end
