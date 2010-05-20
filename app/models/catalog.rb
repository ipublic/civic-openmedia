class Catalog < CouchRestRails::Document
  
  include CouchRest::Validation
  
  ## CouchDB database and record key
  use_database :community
  unique_id :catalog_id 
  
  ## Properties
  property :catalog_id
  property :title
  property :description
  property :publisher_organization_id
  property :catalog_records, :cast_as => ['CatalogRecord'], :default => []
  property :metadata, :cast_as => 'Metadata'#, :default => []

  timestamps!

  ## Callbacks
  before_save :generate_catalog_id
  
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
  def generate_catalog_id
    #Pattern for Unique ID: "class" + "_" + "key"
    self['catalog_id'] = self.class.to_s.pluralize.downcase + '_' + title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
end
