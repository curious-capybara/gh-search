require "search_results"

RSpec.describe SearchResults do
  describe ".from_json" do
    let(:json) do
      {
        total_count: 15,
        items: [
          {name: "Test", html_url: "https://github.com", owner: {avatar_url: "http://imgur.com/image"}}
        ]
      }
    end

    let(:pagination) do
      {
        next: nil,
        prev: nil,
        last: nil,
        first: nil
      }
    end

    it "creates object from json" do
      result = SearchResults.from_json(json, query: "test", pagination: pagination)
      expect(result.total_count).to eq(15)
      expect(result.repos.length).to eq(1)
      expect(result.query).to eq("test")
    end

    it "works when no repos returned" do
      json[:items] = []
      result = SearchResults.from_json(json, query: "test", pagination: pagination)
      expect(result.repos.length).to eq(0)
    end

    it "works when owner does not have avatar" do
      json[:items].first[:owner][:avatar_url] = nil
      result = SearchResults.from_json(json, query: "test", pagination: pagination)
      expect(result.repos.length).to eq(1)
    end
  end
end