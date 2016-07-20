require 'colorize'

module View

  def list_output(arr)
    arr.each_with_index do |item, index|
      puts "#{index+1}: #{item['login']}"
    end
  end

  def select_prompt
    puts "Input selection (int)"
    print "=> "
    gets.chomp.to_i-1
  end

  def display_confirmation(org_name, username, result)
    puts "Added #{username} to #{org_name}. Their status is #{result}.".colorize(:color => :green)
  end

  def display_failure(org_name, username, result)
    puts "FAILED! #{username} was not added to #{org_name}. The result was:".colorize(:color => :light_blue, :background => :red)
    ap result
  end

end
