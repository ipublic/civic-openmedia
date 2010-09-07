class Catalog < CouchRestRails::Document

  require "metadata"
  
  ## Catalogs can appear in any of these DBs: staging, public, community (as defined in Site::DATABASES). 
  ## This is the parent class, with StagingCatalog, PublicCatalog and CommunityCatalog children classes

  ## CouchDB database and record key
  use_database :site
  unique_id :identifier
  
  ## Properties
  property :title
  property :identifier
  property :database_store, :default => 'staging'
  property :metadata, :cast_as => 'Metadata' #, :default => []

  timestamps!

  ## Callbacks
  before_save :generate_identifier
  
  ## Views
  view_by :title
  view_by :title, :identifier
  view_by :database_store

  def datasets
    ds = Dataset.get(:catalog_id => self['identifer'])
    res = ds.nil? ? [] : ds
  end

  def dataset_count
    ds = Dataset.by_catalog_id(:key => self.identifier)
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
    self['identifier'] = self.class.to_s.downcase + '_' + title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
end
