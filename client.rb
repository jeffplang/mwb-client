#!/usr/bin/env ruby

require 'optparse'
require './tag_search'

options = {
  format: :json,
  api_key: ENV['MWB_API_KEY'],
  limit: 50
}

optsparser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby client.rb [options] tag\n\nMalwareBazaar API key is not required, but if provided, uses MWB_API_KEY environment variable.  Can be overridden with key speciied with -k\n\n"
  opts.on "-f format", "--format=format", "Specify output format, csv or json.  Defaults to json" do |format|
    case format
    when 'csv'
      options[:format] = :csv
    when 'json'
      options[:format] = :json
    end
  end

  opts.on "-l limit", "--limit=limit", "Maximum number of results to retrieve.  Defaults to 50" do |limit|
    options[:limit] = limit.to_i if limit =~ /^\d+$/
  end

  opts.on "-k key", "--key=key", "MalwareBazaar API key" do |key|
    options[:api_key] = key if key
  end

  opts.on "-h", "--help", "Prints this help" do
    puts opts
    exit
  end
end

optsparser.parse!

if ARGV.empty?
  puts optsparser
  exit
end

TagSearch.new(ARGV[0], options).run!