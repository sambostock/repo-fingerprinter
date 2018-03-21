#! /usr/bin/env ruby

# frozen_string_literal: true

require 'github_api'

github = Github.new do |config|
  # DO NOT ACCIDENTALLY COMMIT
  config.basic_auth         = 'username:password'
  config.connection_options = { headers: { "X-GitHub-OTP" => '2fa-token' } }
end

File.open('.fingerprint', 'r') do |file|
  file.each_line do |line|
    jwt = line.chomp
    encoded_payload = jwt.split(?.)[1]
    results = github.search.code(q: encoded_payload)

    results.items.each do |result|
      puts result.repository.html_url
    end
  end
end
