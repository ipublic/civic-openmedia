class CatalogRecord < Hash

  include CouchRest::CastedModel
  
  property :dataset_id
  property :formats, :cast_as => ['String'], :default => ['text/csv', 'application/json', 'text/xml']
  
end
