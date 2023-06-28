require "minitest/autorun"
require_relative "clivia_generator"

class CliviaGeneratorTest < Minitest::Test
  # no es necesario rubocop lo detecta
  # def setup
  #   super
  # end

  def test_create_instance_main
    trivia = CliviaGenerator.new
    assert_instance_of CliviaGenerator, trivia
  end

  def test_initial_score
    trivia = CliviaGenerator.new
    score = 0
    assert_equal score, trivia.score
  end
end