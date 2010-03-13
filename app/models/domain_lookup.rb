class DomainLookup < Hash

  include CouchRest::CastedModel
  include Validatable

  property :code
  property :display_value
  property :description
 
  validates_presence_of :code
  validates_presence_of :display_value
  
  def to_s
    property_domain_str = "#{code}"
    property_domain_str = "\n#{display_value}"
    property_domain_str = "\n#{description}" if description
    property_domain_str
  end
end

