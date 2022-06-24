#!/usr/bin/env ruby

require 'optparse'
require 'net/http'
require 'json'
require 'csv'

options = {
  format: :json
}

optsparser = OptionParser.new do |opts|
  opts.banner = "Usage: mwb_client.rb [options] tag"
  opts.on "-f format", "--format=format", "Specify output format, csv or json.  Defaults to json." do |v|
    case v
    when 'csv'
      options[:format] = :csv
    when 'json'
      options[:format] = :json
    end
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

body = {
  'query' => 'get_taginfo',
  'tag' => ARGV[0],
  'limit' => 50
}

fields = ["first_seen", "last_seen", "file_type", "md5_hash", "sha256_hash", "tags", "reporter"]

uri = URI('https://mb-api.abuse.ch/api/v1/')
res = Net::HTTP.post_form(uri, body)

if res.code != "200"
  puts "HTTP Error: #{res.code}"
  puts res.body
  exit(1)
end

parsed = JSON.parse(res.body)

unless ["ok", "no_results"].include? parsed["query_status"]
  puts "API Error: #{parsed["query_status"]}"
  exit(1)
end

data = (parsed['data'] || []).map do |row|
  row["tags"] = row["tags"].join(', ')
  row.slice(*fields)
end

if options[:format] == :csv
  puts data.map(&:values).map(&:to_csv)
else
  puts data.to_json
end
