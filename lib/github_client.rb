require "octokit"
require "search_results"

class GithubClient
  attr_reader :client

  def initialize(client: nil)
    @client = client || Octokit::Client.new
  end

  def search(query, page:)
    response = client.search_repos(query, page: page)
    SearchResults.from_json(response, query: query, pagination: build_pagination_data)
  end

  private

  def build_pagination_data
    rels = client.last_response.rels
    {
      first: pagination_query(rels[:first]),
      next: pagination_query(rels[:next]),
      prev: pagination_query(rels[:prev]),
      last: pagination_query(rels[:last])
    }
  end

  def pagination_query(rel)
    return unless rel

    URI.parse(rel.href).query
  end
end