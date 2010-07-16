class PublicCatalog < Catalog
  require 'catalog'
  use_database :public
end
