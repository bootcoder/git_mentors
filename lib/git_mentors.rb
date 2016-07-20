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
    # @current_mentors = ["klvngann", "toddseller", "jbomotti", "HolixSF", "TopGirlCoder", "ashbymichael", "alfredlam42", "whoisglover", "Coderica", "creatyvtype", "galenscook", "TriathlonCodes", "ckammerl", "jaredsmithse", "lightninglord", "banudalamanli", "RNBrandt", "Zanibas", "DonLang", "benvogcodes", "afayek1", "dianpan", "devin-liu", "ryanau", "XanderPSON", "its-swats", "wenwei63029869", "themcny", "kevinzwh", "hyendler", "EclecticKlos", "markjanzer", "WhaleMonster", "paulozag", "arcman7", "resalisbury", "tmashuang", "nathanmpark", "angelafield"]
    @current_mentors = ["DBC-SF", "asdjjjasiiaweeeweaga232"]
    start_CLI
  end

  def start_CLI

    orgs = find_all_user_orgs
    list_output(orgs)
    selected_org = find_org(select_prompt, orgs)
    team_id = find_org_employees_team_id(selected_org["login"])

    @current_mentors.each do |username|
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


