require 'faraday'
require 'graphql'
require 'uri'

require_relative 'doc'
require_relative 'who'
require_relative 'sample'

class QueryType < GraphQL::Schema::Object
  graphql_name 'Query'

  field :samples, resolver: SamplesResolver
  field :who,     resolver: WHOResolver      # World Health Org. API
  field :doc,     resolver: DocResolver      # Plos.org API
end

class Schema < GraphQL::Schema
  query QueryType
end

# test run
variables = {
  code:  'WHOSIS_000001',
  title: 'DNA'
}

query_string = <<~QUERY
  query SampleStiching($code: String!, $title: String!) {

    who(code:  "WHOSIS") { indicatorCode indicatorName }
    doc(title: "Virus")  { titleDisplay eissn score }

    samples(whoCode: $code, docTitle: $title) {
      id name
      who { indicatorCode indicatorName language }
      doc(title: $title) { id titleDisplay score }
    }
  }
QUERY

puts JSON.pretty_generate(Schema.execute(query: query_string, variables: variables))
