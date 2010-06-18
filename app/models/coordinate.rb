class Coordinate < Hash

  # GeoJSON - http://geojson.org/geojson-spec.html#id2.

  include ::CouchRest::CastedModel
  include Validatable
  
  property :x
  property :y
  
end
