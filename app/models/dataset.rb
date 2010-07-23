class Dataset < CouchRestRails::Document
  
#  require 'content_document'
  require 'connection'
  require 'attachment'

  ## CouchDB database and record key
  use_database :staging
  unique_id :identifier
  
  ## Properties
  property :identifier
  property :title
  property :catalog_id, :default => "staging-catalog"
  property :properties, :cast_as => ["Property"], :default => [] 
  property :metadata, :cast_as => 'Metadata'
#  property :_attachments, :cast_as => ['Attachment']
  
  property :connection, :cast_as => 'Connection'
  
  property :delimiter_character, :default => ","
  property :column_header_row, :type => TrueClass, :default => true

  property :filters, :cast_as => ['DataFilter']
  property :dataset_views, :cast_as => ["String"]

#  property :design_document_name  # This is 'couchrest-type' value
#  property :temporary_file_name
#  property :content_document_id
  
  timestamps!
  
  ## Validations
# This works with new CouchRest Model & Rails 3  validates_uniqueness_of :identifier
  
  ## Views
  view_by :title
  view_by :catalog_id
  view_by :keywords,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'Dataset') && doc['metadata'] && doc['metadata']['keywords']) {
          doc['metadata']['keywords'].forEach(function(keyword){
            emit(keyword, 1);
          });
        }
      }",
    :reduce => 
      "function(keys, values, rereduce) {
        return sum(values);
      }"  
  

  ## Callbacks
  before_save :generate_identifier
  
private
  def generate_identifier
    if !title.blank?
      self['identifier'] = title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
  end

end