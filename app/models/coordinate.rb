class Coordinate < Hash
  # geo microformat: http://microformats.org/wiki/geo
  include ::CouchRest::CastedModel
  include Validatable
  
  property :latitude
  property :longitude
  
  # validates_presence_of [:latitude, :longitude]
  # validates_numericality_of [:latitude, :longitude]
  
end
