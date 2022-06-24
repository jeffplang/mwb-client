require './tag_search'
require 'test/unit'

MockHTTPResponse = Struct.new(:code, :body)

VALID_RESP = {
  query_status: "ok",
  data: [
    {
      sha256_hash: "12345",
      md5_hash: "6789",
      first_seen: "2022-06-23 09:55:13",
      last_seen: "2022-06-23 09:55:13",
      tags: ["foo", "bar", "baz"],
      file_type: "exe",
      reporter: "person",
      extra_data: "asdf"
    }
  ]
}.to_json

class TestTagSearch < Test::Unit::TestCase
  def setup
    @query = TagSearch.new('foo')
  end

  def test_non_200_status_code
    resp = MockHTTPResponse.new('500', 'Internal Server Error')

    assert_raise(SystemExit) { @query.parse_response(resp) }
  end

  def test_api_error_result
    resp = MockHTTPResponse.new('200', '{"query_status":"illegal_tag"}')

    assert_raise(SystemExit) { @query.parse_response(resp) }
  end

  def test_csv_output
    resp = MockHTTPResponse.new('200', VALID_RESP)

    @query.options[:format] = :csv
    parsed = @query.parse_response(resp)

    correct = ["2022-06-23 09:55:13,2022-06-23 09:55:13,exe,6789,12345,\"foo, bar, baz\",person\n"]

    assert_equal correct, @query.formatted_output(parsed)
  end

  def test_json_output
    resp = MockHTTPResponse.new('200', VALID_RESP)

    parsed = @query.parse_response(resp)

    correct = "[{\"first_seen\":\"2022-06-23 09:55:13\",\"last_seen\":\"2022-06-23 09:55:13\",\"file_type\":\"exe\",\"md5_hash\":\"6789\",\"sha256_hash\":\"12345\",\"tags\":\"foo, bar, baz\",\"reporter\":\"person\"}]"

    assert_equal correct, @query.formatted_output(parsed)
  end
end
