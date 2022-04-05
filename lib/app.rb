require "hanami/api"
require "tilt"
require "erubi/capture_end"
require "template"
require "github_client"

class GithubSearch < Hanami::API
  get "/" do
    search_query = params[:q]
    page = params[:page]

    search_results = if search_query
      GithubClient.new.search(search_query, page: page)
    end
    
    Template.render(:index, search_results: search_results)
  end
end