class Dataset < CouchRestRails::Document
  
#  require 'content_document'
  require 'connection'

  ## CouchDB database and record key
  use_database :staging
  unique_id :identifier
  
  ## Properties
  property :identifier
  property :title
  property :catalog_id
#  property :content_document_id
  property :connection, :cast_as => 'Connection'
  property :uploaded_content_type
  property :uploaded_content
  
  property :properties, :cast_as => ["Property"], :default => [] 
  property :metadata, :cast_as => 'Metadata'

  property :filters, :cast_as => ['DataFilter']

  property :design_document_name  # This is 'couchrest-type' value
  property :dataset_views, :cast_as => ["String"]
  
  timestamps!
  
  ## Validations
# This works with new CouchRest Model & Rails 3  validates_uniqueness_of :identifier
  
  ## Views
  view_by :title
  view_by :catalog_id

  ## Callbacks
  before_save :generate_identifier

  def uploaded_file=(ds_field)
    conn = Connection.new
#    conn.file_path = ds_field.dirname
    conn.file_name = ds_field.original_filename
    self.connection = conn
    self.uploaded_content_type = ds_field.content_type.chomp
    self.uploaded_content = ds_field.read
  end

private
  def generate_identifier
    if !title.blank?
      self['identifier'] = title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
  end

end