require 'net/http'
require 'json'
require 'csv'

class TagSearch
  FIELDS       = ["first_seen", "last_seen", "file_type", "md5_hash", "sha256_hash", "tags", "reporter"]
  ENDPOINT_URI = URI('https://mb-api.abuse.ch/api/v1/')

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
      parsed.map(&:values).map(&:to_csv).join
    else
      parsed.to_json unless parsed.empty?
    end
  end

  def request
    body = {
      'query' => 'get_taginfo',
      'tag' => @tag,
      'limit' => @options[:limit]
    }

    req = Net::HTTP::Post.new(ENDPOINT_URI)
    req.set_form_data(body)

    req['API-KEY'] = options[:api_key] if @options[:api_key]

    req
  end

  def run!
    resp = Net::HTTP.start(ENDPOINT_URI.hostname, ENDPOINT_URI.port, use_ssl: true) do |http|
      http.request(request)
    end

    parsed = parse_response(resp)

    puts formatted_output(parsed)
  end
end