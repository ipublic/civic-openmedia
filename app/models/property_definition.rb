class PropertyDefinition < Hash
  require 'domain_lookup'
  include CouchRest::CastedModel
  include CouchRest::Validation
  
  property :name
  property :alias_name  # use alias for synonyms, e.g.; lat, long, address
  property :data_type   # simplified set? (e.g.; number, string, lookup_value)
  property :default_value
  property :ordinal_position
  property :description

# Hashes may not contain :cast_as
#  property :domain_lookup, :cast_as => 'DomainLookup'

#  validates_presence_of :name
 
  def to_s
    property_str = "#{name}"
    property_str << "\n#{alias_name}" if display_name
    property_str << "\n#{data_type}, " if data_type
    property_str << "\n#{default_value}, " if data_type
    property_str << "\n#{ordinal_position}, " if data_type
    property_str << "\n#{description}" if description
    property_str
  end
end

