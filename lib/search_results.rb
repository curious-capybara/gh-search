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
    attribute :avatar, Types::Optional::String
  end
  attribute :pagination do
    attribute :next, Types::Optional::String
    attribute :prev, Types::Optional::String
    attribute :last, Types::Optional::String
    attribute :first, Types::Optional::String
  end

  def self.from_json(json, query:, pagination:)
    self.new(
      query: query,
      total_count: json[:total_count],
      repos: json[:items].map do |item|
        {
          name: item[:name],
          url: item[:html_url],
          description: item[:description],
          avatar: item[:owner][:avatar_url]
        }
      end,
      pagination: pagination
    )
  end
end