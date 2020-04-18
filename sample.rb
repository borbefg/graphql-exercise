class Sample < GraphQL::Schema::Object
  field :id,   ID,     null: true
  field :name, String, null: true

  # Option 1: Params from back-end way
  # See app.rb line 35
  field :who, [WHO], null: true

  def who
    # object -> the current object
    WHOResolver.new(object: object, context: context, field: 'who').resolve(code: object[:who_code])
  end

  # Option 2: Params from front-end way
  # See app.rb line 36
  field :doc, **DocResolver.field_options
end

class SamplesResolver < GraphQL::Schema::Resolver
  type [Sample], null: true

  argument :who_code,  String, required: false
  argument :doc_title, String, required: false

  def resolve(who_code:, doc_title:)
    samples = [
      { id: 1, name: 'Sample 1', who_code: 'WHOSIS_000001', doc_title: 'DNA' },
      { id: 2, name: 'Sample 2', who_code: 'WHOSIS_000001', doc_title: 'DNA' },
      { id: 3, name: 'Sample 3', who_code: 'WHOSIS_000002', doc_title: 'Duplexes' },
      { id: 4, name: 'Sample 4', who_code: 'WHOSIS_000003', doc_title: 'Virus' },
      { id: 5, name: 'Sample 5', who_code: 'AIR_1',         doc_title: 'DNA' },
      { id: 6, name: 'Sample 6', who_code: 'AIR_2',         doc_title: 'Duplexes' },
      { id: 7, name: 'Sample 7', who_code: 'AIR_3',         doc_title: 'Virus' }
    ]

    samples.select do |sample|
      sample[:who_code] == who_code && sample[:doc_title] == doc_title
    end
  end
end
