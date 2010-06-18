class Catalog < CouchRestRails::Document
  
  include CouchRest::Validation
  
  ## CouchDB database and record key
  use_database :world
  unique_id :identifier 
  
  ## Properties
  property :title
  property :identifier
  property :catalog_records, :cast_as => ['ContentDocument'], :default => []
  property :metadata, :cast_as => 'Metadata'#, :default => []

  timestamps!

  ## Callbacks
  before_save :generate_identifier
  
  ## Views
  view_by :title
  view_by :publisher_organization_id
  view_by :publisher_organization_id, :title

  def get_catalog_records
    result = self.by_catalog_id(:key => self['_id'] )
  end

  def catalog_record_count
    result = CatalogRecord.by_catalog_id(:key => self['catalog_id']).count
  end

  def publisher_organization_name
    result = Organization.get(self.metadata['publisher_organization_id']).name
  end

private
  def generate_identifier
    self['identifier'] = title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
end
