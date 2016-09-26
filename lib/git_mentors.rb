require 'io/console'
require 'pry-byebug'
require 'awesome_print'
require 'dotenv'
Dotenv.load

require_relative 'github_adapter'
require_relative 'view'

class GitMentors

  include View

  def initialize

    @github = GithubAdapter.new(get_email,get_password)

    # Initialize with list of recurring mentors to add.
    current_mentors = ["klvngnn", "toddseller", "jbomotti", "HolixSF", "TopGirlCoder", "ashbymichael", "alfredlam42", "whoisglover", "Coderica", "creatyvtype", "galenscook", "ckammerl", "jaredsmithse", "lightninglord", "banudalamanli", "RNBrandt", "Zanibas", "DonLang", "benvogcodes", "afayek1", "dianpan", "devin-liu", "ryanau", "XanderPSON", "its-swats", "wenwei63029869", "themcny", "kevinzwhuang", "hyendler", "EclecticKlos", "markjanzer", "WhaleMonster", "paulozag", "arcman7", "resalisbury", "tmashuang", "nathanmpark", "angelafield"]
    test_mentors = ["DBC-SF", "laksdjlfkajsdflkafjlskdjf"]

    # Set list from test to current before running in production.
    ARGV.length > 0 ? main_CLI(ARGV) : main_CLI(test_mentors)

  end

  def main_CLI(mentor_list)

    # List all orgs that a user belongs to.
    # Allow them to select one to proceed.
    display_welcome
    orgs = find_all_user_orgs
    list_output(orgs, "\nPlease select an org you currently belong to.\nOrgs listed in chronological order.\n\nNOTE: Only orgs you have ALREADY joined are displayed.\nGo to https://github.com/ORG-NAME to check your invitation status.\n")
    selected_org = find_org(select_prompt, orgs)
    team_id = find_org_employees_team_id(selected_org["login"])

    # Display all usernames to be added.
    # Require confirmation before proceeding.
    system('clear')
    display_welcome
    list_output(mentor_list, "\n The following usernames will\n be added to #{selected_org['login']}")
    return unless confirmation_prompt == "y"

    # Add each username to the selected github org under the employees team.
    # Display confirmation of each user added.
    mentor_list.each do |username|
      result = add_user(username, team_id)
      if result["state"] == "pending" || result["state"] == "active"
        display_confirmation(selected_org["login"], username, result["state"])
      else
        display_failure(selected_org["login"], username, result)
      end
    end

  end

  private

  def find_all_user_orgs
      # ap @github.get_orgs
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


