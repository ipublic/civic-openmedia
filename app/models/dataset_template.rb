class DatasetTemplate < CouchRest::ExtendedDocument

  ## Scaffolding for generic OpenMedia dataset model

  require "metadata"
  
  use_database :staging
  
  property :series_id
  property :catalog_id, :default => "staging"
  property :metadata, :cast_as => 'Metadata'
  
  timestamps!

  view_by :series_id
  
end
