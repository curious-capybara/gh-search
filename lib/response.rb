require 'dry-struct'

module Types
  include Dry.Types()
end

class SearchResults < Dry::Struct
  attribute :total_count, Types::Integer
  attribute :query, Types::String
  attribute :repos, Types::Array do
    attribute :name, Types::String
    attribute :url, Types::String
    attribute :description, Types::Optional::String
  end

  def self.from_json(json, query)
    self.new(
      query: query,
      total_count: json["total_count"],
      repos: json["items"].map do |item|
        {
          name: item["name"],
          url: item["html_url"],
          description: item["description"]
        }
      end
    )
  end
end