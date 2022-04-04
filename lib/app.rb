require "hanami/api"
require "tilt"
require "erubi/capture_end"
require "json"
require "http"
require "template"
require "response"

class GithubSearch < Hanami::API
  get "/" do
    search_query = params[:q]

    search_results = if search_query
      HTTP.get("https://api.github.com/search/repositories?q=#{search_query}").to_s.
      then{|resp| JSON.parse(resp)}.
      then{|json| SearchResults.from_json(json, "hanami")}
    end
    
    Template.render(:index, search_results: search_results)
  end
end