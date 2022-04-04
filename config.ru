# frozen_string_literal: true

$:.unshift File.join(File.dirname(__FILE__), "lib")

require "app"

run GithubSearch.new