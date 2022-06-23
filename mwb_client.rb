#!/usr/bin/env ruby

require 'optparse'

options = {
  format: :json
}

OptionParser.new do |opts|
  opts.banner = "Usage: mwb_client.rb [options] tag_query"
  opts.on "-f", "--format", "Specify output format, CSV or JSON.  Defaults to JSON." do |v|
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
end.parse!
