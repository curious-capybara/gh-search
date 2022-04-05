require "octokit"
require "search_results"

module GithubClient
  def self.search(query)
    client = Octokit::Client.new
    client.search_repos(query).
    then{|json| SearchResults.from_json(json, query: query)}
  end
end