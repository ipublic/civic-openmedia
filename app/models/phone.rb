class Phone < Hash
  include ::CouchRest::CastedModel
  include Validatable

  validates_presence_of :identifier
  validates_presence_of :value
  
  property :type
  property :number
 
  def to_s
    property_domain_str = "#{type}"
    property_domain_str = "#{number}"
    property_domain_str
  end
end

