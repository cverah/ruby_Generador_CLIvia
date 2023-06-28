module Validationable
  # validation extension .json
  def validation_extension_json
    file = ARGV[0]
    # para el gets chomp
    ARGV.clear
    if file.nil?
      @filename = File.open("scores.json", "a+")
    elsif file.match?(/.*\json$/)
      @filename = File.open(file, "a+")
    else
      puts "please enter a name with .json extension"
      exit
    end
  end

  # validation range options del question
  def validation_range_options(all_options)
    answer = 0
    until answer >= 1 && answer <= all_options.length
      print "> "
      answer = gets.chomp.to_i
      if answer < 1 || answer > all_options.length
        puts "the option is not with the range enter [1- #{all_options.length}]"
      end
    end
    # answer tipo entero
    answer
  end

  # validation input save score Y y o N n
  def validation_save_score
    action = ""
    until action.match?(/^(y|n)$/i)
      print "> "
      action = gets.chomp
      puts "invalidity option enter y or n" unless action.match?(/^(y|n)$/i)
    end
    action.downcase
  end
end
