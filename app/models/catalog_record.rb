class CatalogRecord < CouchRestRails::Document
  
  include CouchRest::Validation
  
  ## CouchDB database and record key
  use_database :community
  unique_id :catalog_record_id 
  
  ## Properties
  property :catalog_record_id 
  property :catalog_id 
  property :dataset_id
  property :formats, :cast_as => ['String'], :default => ['text/csv', 'application/json', 'text/xml']
  
  timestamps!
  
  ## Validations
  validates_presence_of :dataset_id, :catalog_id

  ## Callbacks
  before_save :generate_catalog_record_id
  
  ## Views
  view_by :catalog_id
  

private
  def generate_catalog_record_id
    self['catalog_record_id'] = self.class.to_s.downcase + '_' + self['dataset_id'] 
    
    # self['catalog_record_id'] = self.class.to_s.downcase + '_' +  abbreviation.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
end
