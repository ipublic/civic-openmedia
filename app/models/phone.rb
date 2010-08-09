class Phone < Hash
  include ::CouchRest::CastedModel
  include Validatable

  property :type
  property :number
 
  # validates_presence_of :type
  # validates_presence_of :number
  
  def to_s
    property_domain_str = "#{type}"
    property_domain_str = "#{number}"
    property_domain_str
  end
end

