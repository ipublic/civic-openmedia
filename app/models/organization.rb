class Organization < Hash
  include ::CouchRest::CastedModel
  
  property :name
  property :website
  property :description
 
  def to_s
    organization_str = "#{name}"
    organization_str = "#{website}" if website
    organization_str = "\n#{description}" if description
    organization_str
  end
end

