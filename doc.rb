class Doc < GraphQL::Schema::Object
  field :id,            String, null: true
  field :title_display, String, null: true
  field :eissn,         String, null: true
  field :score,         String, null: true
end

class DocResolver < GraphQL::Schema::Resolver
  type [Doc], null: true

  argument :title, String, required: true

  def resolve(title:)
    api_host = 'http://api.plos.org'
    api_uri  = "/search?q=title:#{title}"
    res = JSON.parse(Faraday.get(URI.join(api_host, api_uri)).body)
    res.dig('response', 'docs')
  end
end
