require "vcr"
require "app"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.describe GithubSearch do
  it "returns code 200 with empty results" do
    env = {"PATH_INFO" => "/", "REQUEST_METHOD" => "GET"}
    code, headers, body = subject.call(env)

    expect(code).to eq(200)
    expect(body.first).to include("Type something in the search bar")
  end

  it "searches for repos" do
    VCR.use_cassette("search-hanami") do
      env = {"PATH_INFO" => "/", "REQUEST_METHOD" => "GET", "QUERY_STRING" => "q=hanami"}
      code, headers, body = subject.call(env)

      expect(code).to eq(200)
      expect(body.first).to include("hanami")
    end
  end

  it "does not display prev pagination link on first results page" do
    VCR.use_cassette("search-hanami") do
      env = {"PATH_INFO" => "/", "REQUEST_METHOD" => "GET", "QUERY_STRING" => "q=hanami"}
      code, headers, body = subject.call(env)

      expect(code).to eq(200)
      expect(body.first).to include("Next page")
      expect(body.first).not_to include("Previous page")
    end
  end

  it "displays prev pagination link on second results page" do
    VCR.use_cassette("search-hanami-page-2") do
      env = {"PATH_INFO" => "/", "REQUEST_METHOD" => "GET", "QUERY_STRING" => "q=hanami&page=2"}
      code, headers, body = subject.call(env)

      expect(code).to eq(200)
      expect(body.first).to include("Next page")
      expect(body.first).to include("Previous page")
    end
  end

  it "displays not found" do
    VCR.use_cassette("search-garbage") do
      env = {"PATH_INFO" => "/", "REQUEST_METHOD" => "GET", "QUERY_STRING" => "q=jvzoec48n49cn9s"}
      code, headers, body = subject.call(env)

      expect(code).to eq(200)
      expect(body.first).to include("No results found")
    end
  end
end