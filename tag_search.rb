require 'net/http'
require 'json'
require 'csv'

class TagSearch
  FIELDS       = ["first_seen", "last_seen", "file_type", "md5_hash", "sha256_hash", "tags", "reporter"]
  ENDPOINT_URL = 'https://mb-api.abuse.ch/api/v1/'

  attr_accessor :options

  def initialize(tag, options = {})
    @tag = tag
    @options = options
  end

  def parse_response(resp)
    if resp.code != "200"
      puts "HTTP Error: #{resp.code}"
      puts resp.body
      exit(1)
    end

    parsed = JSON.parse(resp.body)

    unless ["ok", "no_results"].include? parsed["query_status"]
      puts "API Error: #{parsed["query_status"]}"
      exit(1)
    end

    (parsed['data'] || []).map do |row|
      row["tags"] = row["tags"].join(', ')
      row.slice(*FIELDS)
    end
  end

  def formatted_output(parsed)
    if @options[:format] == :csv
      parsed.map(&:values).map(&:to_csv)
    else
      parsed.to_json
    end
  end

  def run!
    body = {
     'query' => 'get_taginfo',
     'tag' => @tag,
     'limit' => @options[:limit] || 50
    }

    resp = Net::HTTP.post_form(URI(ENDPOINT_URL), body)

    parsed = parse_response(resp)

    puts formatted_output(parsed)
  end
end