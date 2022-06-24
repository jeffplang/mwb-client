#!/usr/bin/env ruby

require 'optparse'
require './tag_search'

options = {
  format: :json
}

optsparser = OptionParser.new do |opts|
  opts.banner = "Usage: client.rb [options] tag"
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

TagSearch.new(ARGV[0], options).run!