class WHO < GraphQL::Schema::Object
  field :indicator_code, String, null: true
  field :indicator_name, String, null: true
  field :language,       String, null: true
end

class WHOResolver < GraphQL::Schema::Resolver
  type [WHO], null: true

  argument :code, String, required: true

  def resolve(code:)
    api_host = 'https://ghoapi.azureedge.net'
    api_uri  = "/api/Indicator?$filter=contains(IndicatorCode,'#{code}')"
    res = JSON.parse(Faraday.get(URI.join(api_host, api_uri)).body)
    res['value'].map { |a| a.transform_keys(&method(:snakecase)) }
  end
end

def snakecase(string)
  string.gsub(/(.)([A-Z])/, '\1_\2').downcase
end
