require 'pry-byebug'
require 'awesome_print'
require 'dotenv'
Dotenv.load

require_relative 'github_adapter'
require_relative 'view'

class GitMentors

  include View

  def initialize
    @github = GithubAdapter.new(ENV['GIT_EMAIL'],ENV['GIT_PASSWORD'])
    start_CLI
  end

  def start_CLI
  # username var needs to be replaced by a method to iterate over list of GH usernames
    username = "DBC-SF"

    orgs = find_all_user_orgs
    list_output(orgs)
    selected_org = find_org(select_prompt, orgs)
    team_id = find_org_employees_team_id(selected_org["login"])
    result = add_user(username, team_id)
    if result["state"] == "pending" || result["state"] == "active"
      display_confirmation(selected_org["login"], username, result["state"])
    else
      display_failure(selected_org["login"], username, result)
    end
  end

  private

  def find_all_user_orgs
    @github.get_orgs.reverse
  end

  def add_user(username, team_id)
    @github.team_add_user(username, team_id)
  end

  def find_org(org_index, orgs)
    orgs[org_index]
  end

  def find_org_employees_team_id(selected_org)
    teams = @github.get_org_teams(selected_org).select{|team| team["name"] == "Employees"}
    teams.first["id"] unless teams.empty?
  end

end

GitMentors.new
puts "All done, Have a nice day!"


