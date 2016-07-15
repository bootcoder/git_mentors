require_relative 'github_adapter'
require 'pry-byebug'
require 'awesome_print'
require 'dotenv'
Dotenv.load

class GitMentors

  def initialize
    @github = GithubAdapter.new(ENV['GIT_EMAIL'],ENV['GIT_PASSWORD'])
    start_CLI
  end

  def start_CLI
    orgs = find_all_user_orgs
    list_output(orgs)
    input_org = find_org(select_prompt, orgs)
    team_id = find_org_employees_team_id(input_org["login"])
    ap add_user("DBC-SF", team_id)
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


  def list_output(arr)
    arr.each_with_index do |item, index|
      puts "#{index+1}: #{item['login']}"
    end
  end

  def select_prompt
    puts "Select Cohort (int)"
    print "=> "
    gets.chomp.to_i
  end

end

git_mentors = GitMentors.new
