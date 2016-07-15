require 'pry-byebug'
require 'httparty'
require 'awesome_print'

class GithubAdapter

  include HTTParty

  base_uri 'https://api.github.com'

  def initialize(u, p)
    @auth = {username: u, password: p}
  end

  def test(endpoint)
    self.class.get(endpoint, basic_auth: @auth)
  end

  def get_orgs
    self.class.get("/user/orgs", {basic_auth: @auth, query: {per_page: 50}})
  end

  def get_org_teams(org)
    self.class.get("/orgs/#{org}/teams", basic_auth: @auth)
  end

  def team_add_user(username, team_id)
    # PUT /teams/:id/memberships/:username
    self.class.put("/teams/#{team_id}/memberships/#{username}", basic_auth: @auth)
  end

end
