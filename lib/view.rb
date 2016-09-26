require 'colorize'

module View

  def list_output(arr, msg = "")
    puts msg
    arr.each_with_index do |item, index|
      item = item['login'] if item['login']
      color  = index % 2 == 0 ? {color: :black, background: :white} : {color: :blue, background: :white}
      output = "  #{index+1}: #{item}"
      puts standardize_length(output,50).colorize(color)
    end
    puts standardize_length("\nTotal items listed: #{arr.length}", 50).colorize(:green)
  end

  def get_email
    return ENV['GIT_EMAIL'] if ENV['GIT_EMAIL']
    print "Git email: >"
    $stdin.gets.chomp
  end

  def get_password
    return ENV['GIT_PASSWORD'] if ENV['GIT_PASSWORD']
    print "Git password: (Never Stored) >"
    STDIN.noecho(&:gets).chomp
  end

  def select_prompt
    puts "Input selection (int)"
    print "=> "
    $stdin.gets.chomp.to_i-1
  end

  def confirmation_prompt
    puts
    puts standardize_length("Do you want to proceed? `y`", 50).colorize(color: :black, background: :yellow)
    print "=> "
    $stdin.gets.chomp.downcase
  end

  def display_welcome
    system 'clear'
    puts standardize_length("",100).blue.on_white
    puts standardize_length("",100).blue.on_white
    puts standardize_length("    git_mentors is in open BETA.",100).blue.on_white
    puts standardize_length("    Contributions welcome: Fork & Submit PR",100).blue.on_white
    puts standardize_length("    Feedback welcome: Submit via issueshttps://github.com/bootcoder/git_mentors.",100).blue.on_white
    puts standardize_length("    https://github.com/bootcoder/git_mentors.",100).blue.on_white
    puts standardize_length("",100).blue.on_white
    puts standardize_length("    Usage: Simply add a space delimited list of usernames to the",100).blue.on_white
    puts standardize_length("    command line when executing this program. (ARGV)",100).blue.on_white
    puts standardize_length("    If you have recurring usernames to add you can input them into",100).blue.on_white
    puts standardize_length("    the initialize method within the git_mentors.rb file",100).blue.on_white
    puts standardize_length("    under the variable `current_mentors`",100).blue.on_white
    puts standardize_length("    as an array of strings",100).blue.on_white
    puts standardize_length("    If no ARGV input is passed the script will assume you wanted to",100).blue.on_white
    puts standardize_length("    use the existing usernames and proceed accordingly",100).blue.on_white
    puts standardize_length("",100).blue.on_white
    puts standardize_length("",100).blue.on_white
    unless ENV['GIT_EMAIL'] && ENV['GIT_PASSWORD']
      puts "\nTIP: Enable caching Username / Password\n\nTo store you git credientials for easy use,\nsimply create a `.env` file in the root directory\nof this gem. Format entries as:\nGIT_EMAIL=you@youremail.com\nGIT_PASSWORD=fuzzyNurplepHotob00thcIRCA1492".colorize(:red)
    end
  end

  def display_confirmation(org_name, username, result)
    puts "Added #{username} to #{org_name}. Their status is #{result}.".colorize(:color => :green)
  end

  def display_failure(org_name, username, result)
    puts "FAILED! #{username} was not added to #{org_name}. The result was:".colorize(:color => :light_blue, :background => :red)
    ap result
  end

  def standardize_length(input_string, length)
    return input_string if input_string.length > length
    until input_string.length == length
      input_string.concat(" ")
    end
    input_string
  end

end
