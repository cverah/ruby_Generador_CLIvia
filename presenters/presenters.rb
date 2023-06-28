module Presenterable
  def print_welcome
    puts ("#" * 35).colorize(:light_black)
    puts "#   Welcome to Clivia Generator   #".colorize(color: :green, mode: :italic)
    puts ("#" * 35).colorize(:light_black)
  end

  def print_score(score)
    # print the score message
    puts "\nWell done! Your score is #{score}"
    puts ("-" * 50).colorize(color: :green, mode: :bold)
    puts "Do you want to save your score? (y/n)"
  end
end
