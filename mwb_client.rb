#!/usr/bin/env ruby

require 'optparse'

options = {
  format: :json
}

OptionParser.new do |opts|
  opts.banner = "Usage: mwb_client.rb [options] tag_query"
  opts.on "-f", "--format", "Specify output format, XML or JSON.  Defaults to JSON." do |v|
    case v
    when 'xml'
      options[:format] = :xml
    when 'json'
      options[:format] = :json
    end
  end

  opts.on "-h", "--help", "Prints this help" do
    puts opts
    exit
  end
end.parse!
