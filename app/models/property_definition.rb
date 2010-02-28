class PropertyDefinition < Hash
  include ::CouchRest::CastedModel
  include Validatable
  
  validates_presence_of :name
  
  property :name
  property :display_name
  property :data_type # simplified set? (e.g.; number, string, lookup_value)
  property :property_hash, :cast_as => 'PropertyHash'
  property :ordinal_position
  property :description
 
  def to_s
    property_str = "#{name}"
    property_str << "\n#{display_name}" if display_name
    property_str << "\n#{data_type}, " if data_type
    property_str << "\n#{domain_url}, " if domain_url
    property_str << "\n#{publish_property}, " if publish_property
    property_str << "\n#{canonical_property}, " if canonical_property
    property_str << "\n#{processing_instructions}, " if processing_instructions
    property_str << "\n#{description}" if description
    property_str
  end
end

