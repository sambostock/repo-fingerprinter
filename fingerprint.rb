#! /usr/bin/env ruby

# frozen_string_literal: true

require 'git'
require 'jwt'

SSH_PREFIX = /git@(?<host>[^:]+):/
HTTPS_PREFIX = %r{https://(?<host>[^/]+)/}
PATH = %r{(?<owner>[^/]+)/(?<repo>.+)\.git}
GITHUB_REMOTE_PATTERN = %r{\A(?:#{SSH_PREFIX}|#{HTTPS_PREFIX})#{PATH}\z}

File.open('.fingerprint', 'a') do |file|
  Git.open(Dir.pwd).remotes.each do |remote|
    file.puts(JWT.encode(
      remote.url.match(GITHUB_REMOTE_PATTERN).named_captures,
      nil,
      'none',
    ))
  end
end

File.open('.fingerprint', 'r') do |file|
  file.each_line do |line|
    puts JWT.decode(line.chomp, nil, false).first
  end
end
