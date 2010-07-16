class StagingCatalog < Catalog
  require 'catalog'
  use_database :staging
end
