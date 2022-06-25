# mwb-client

A small utility for querying tags in the MalwareBazaar database.

```
Usage: ruby client.rb [options] tag

MalwareBazaar API key is not required, but if provided, uses MWB_API_KEY environment variable.  Can be overridden with key speciied with -k

    -f, --format=format              Specify output format, csv or json.  Defaults to json
    -l, --limit=limit                Maximum number of results to retrieve.  Defaults to 50
    -k, --key=key                    MalwareBazaar API key
    -h, --help                       Prints this help
```

To run tests, install `Test::Unit` with 

```
$ bundle install --with=development
```

and run with

```
$ ruby tag_search_test.rb
```