  class Property < Hash
  #  require 'domain_lookup'
    include CouchRest::CastedModel
    include CouchRest::Validation
  
    property :name
    property :uri
  #  property :alias_name  # use alias for synonyms, e.g.; lat, long, address
    property :data_type, :default => 'String'   # simplified set? (e.g.; number, string, lookup_value)
    property :definition
    property :default_value
    property :example_value
  
    # use this property to generate CounchDB views?
    property :query_property, :default => false

  # Hashes may not contain :cast_as
  #  property :domain_lookup, :cast_as => 'DomainLookup'

  #  validates_presence_of :name
 
    def to_s
      property_str = "#{name}"
      property_str << ", \n#{uri}" if uri
      property_str << ", \n#{data_type}" if data_type
      property_str << ", \n#{definition}" if definition
      property_str << ", \n#{default_value} " if default_value
      property_str << ", \n#{ordinal_position} " if ordinal_position
      property_str << ", \n#{example_value} " if example_value
      property_str << ", \n#{query_property} " if query_property
      property_str
    end
  end

