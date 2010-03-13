class PropertyDefinition < Hash
  include ::CouchRest::CastedModel
  include Validatable
  
  property :name
  property :alias_name  # use alias for synonyms, e.g.; lat, long, address
  property :data_type   # simplified set? (e.g.; number, string, lookup_value)
  property :default
  property :domain_lookup, :cast_as => 'DomainLookup'
  property :ordinal_position
  property :description

  validates_presence_of :name
 
  def to_s
    property_str = "#{name}"
    property_str << "\n#{alias_name}" if display_name
    property_str << "\n#{data_type}, " if data_type
    property_str << "\n#{domain_url}, " if domain_url
    property_str << "\n#{publish_property}, " if publish_property
    property_str << "\n#{canonical_property}, " if canonical_property
    property_str << "\n#{processing_instructions}, " if processing_instructions
    property_str << "\n#{description}" if description
    property_str
  end
end

