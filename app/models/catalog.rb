class Catalog < CouchRestRails::Document
  
  ## Catalogs can appear in any of these DBs: staging, public, community. This is the 
  ## parent class, with StagingCatalog, PublicCatalog and CommunityCatalog children classes

  require "metadata"
  
  ## CouchDB database and record key
  use_database :site
  unique_id :identifier
  
  ## Properties
  property :title
  property :identifier
  property :storage_database
  property :metadata, :cast_as => 'Metadata' #, :default => []

  timestamps!

  ## Callbacks
  before_save :generate_identifier
  
  ## Views
  view_by :title

  def datasets
    ds = Dataset.get(:catalog_id => self['identifer'])
    res = ds.nil? ? [] : ds
  end

  def dataset_count
    ds = Dataset.get(:catalog_id => self['identifier'])
    count = ds.nil? ? 0 : ds.count
  end

  def publisher_organization_name
    result = Organization.get(self.metadata['publisher_organization_id']).name
  end

private
  # Catalog database defaults to 'staging'
  # def assign_database
  #   catalog_types = %w(staging public community)
  #   db_name = catalog_types.include?(self.catalog_type) ? self.catalog_type : 'staging'
  #   use_database db_name.to_sym
  # end
  
  def generate_identifier
    self['identifier'] = title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
end
