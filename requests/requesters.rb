module Requesterable
  def select_main_menu_action
    # solicitar al usuario las acciones "random | scores | exit"
    gets_option("> ", ["random", "scores", "exit"])
  end

  def ask_question(question)
    # displaying and capturing data
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
    # decode ANSI
    puts "Question: #{parse_questions(question[:question])}"
    questions_all = (question[:incorrect_answers] << question[:correct_answer]).shuffle
    # shuffle para que randomize
    all_options = parse_questions(questions_all).shuffle
    count = 1
    all_options.each do |option|
      puts "#{count}. #{option}"
      count = count.next
    end
    validation_range_options = validation_range_options(all_options)
    ask_questions(validation_range_options, all_options, question[:correct_answer])
  end

  def will_save?(score)
    # agarrar la entrada del usuario
    # solicite al usuario que le dé un nombre al score si no hay un nombre dado, configúrelo como Anónimo
    print_score(score)
    # retorna y o n
    if validation_save_score == "n"
      start
    else
      puts "Type the name to assign to the score"
      print "> "
      name = gets.chomp
      name = "Anonymous" if name == ""
      save({ name: name, score: score })
    end
  end

  def gets_option(prompt, options)
    # prompt for an input
    # keep going until the user gives a valid option
    action = ""
    until options.include?(action)
      puts options.join(" | ").colorize(:light_green)
      print prompt
      action = gets.chomp
      case action
      when "random" then random_trivia
      when "scores" then parse_scores
      when "exit" then puts "Thanks for using Clivia"
      else
        puts "Invalite options"
      end
    end
    action
  end
end
