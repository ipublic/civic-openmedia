class PropertyHash < Hash
  include ::CouchRest::CastedModel
  include Validatable

  validates_presence_of :identifier
  validates_presence_of :value
  
  property :identifier
  property :value
  property :description
 
  def to_s
    property_domain_str = "#{identifier}"
    property_domain_str = "\n#{value}"
    property_domain_str = "\n#{description}" if description
    property_domain_str
  end
end

