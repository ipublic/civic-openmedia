class Dataset < CouchRestRails::Document
  
  require 'content_document'
  require 'connection'

  ## CouchDB database and record key
  use_database :staging
  unique_id :identifier
  
  ## Properties
  property :title
  property :identifier
  property :content_document_id
  property :connection, :cast_as => 'Connection'
  property :uploaded_content_type
  property :uploaded_content
  
  property :properties, :cast_as => ["Property"], :default => [] 
  property :metadata, :cast_as => 'Metadata'
  property :filters, :cast_as => ['DataFilter']

  property :design_document_name  # This is 'couchrest-type' value
  property :dataset_views, :cast_as => ["String"]
  
  timestamps!

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
        self['identifier'] = self.class.to_s.pluralize.downcase + '_' +  title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
      end
    end


end