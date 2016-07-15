require 'pry-byebug'
require 'awesome_print'
require 'dotenv'
Dotenv.load

require_relative 'github_adapter'

class GitMentors

  def initialize
    @github = GithubAdapter.new(ENV['GIT_EMAIL'],ENV['GIT_PASSWORD'])
    start_CLI
  end

  def start_CLI

    username = "DBC-SF"

    orgs = find_all_user_orgs
    display_list_output(orgs)
    input_org = find_org(display_select_prompt, orgs)
    team_id = find_org_employees_team_id(input_org["login"])
    result = add_user(username, team_id)
    return display_confirmation(input_org["login"], username, result["state"]) if result["state"] == "pending"
    display_failure(input_org["login"], username, result)
  end

  private

  def find_all_user_orgs
    @github.get_orgs.reverse
  end

  def add_user(username, team_id)
    @github.team_add_user(username, team_id)
  end

  def find_org(org_index, orgs)
    orgs[org_index-1]
  end

  def find_org_employees_team_id(input_org)
    teams = @github.get_org_teams(input_org).select{|team| team["name"] == "Employees"}
    teams.first["id"] if !teams.empty? && teams.first["name"] == "Employees"
  end


  def display_list_output(arr)
    arr.each_with_index do |item, index|
      puts "#{index+1}: #{item['login']}"
    end
  end

  def display_select_prompt
    puts "Select Cohort (int)"
    print "=> "
    gets.chomp.to_i
  end

  def display_confirmation(org_name, username, result)
    puts "Added #{username} to #{org_name}. Their status is #{result}."
  end

  def display_failure(org_name, username, result)
    puts "FAILED! #{username} was not added to #{org_name}. The result was:"
    ap result
  end

end

GitMentors.new
