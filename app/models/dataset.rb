class Dataset < CouchRestRails::Document
  
#  require 'content_document'
  require 'connection'

  ## CouchDB database and record key
  use_database :staging
  unique_id :identifier
  
  ## Properties
  property :identifier
  property :title
  property :catalog_id, :default => "staging-catalog"
  property :properties, :cast_as => ["Property"], :default => [] 
  property :metadata, :cast_as => 'Metadata'
  
  property :connection, :cast_as => 'Connection'
  
  property :delimiter_character, :default => ","
  property :column_header_row, :type => TrueClass, :default => true
#  property :unique_id_property

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


  ## Methods
  
  # CouchRest design doc
  def create_design_document
    if !self.identifier.blank?
      @des = CouchRest::Design.new
      @des.name = self.identifier
      @des.database = self.database
      @des.save
    else
      nil
    end
  end
  
  # Dataset properties
  def add_property(property_hash)
    property_name = property_hash['name']
    unless property_name.nil?
      idx = property_index_by_name(property_name)
      self.properties << property_hash if idx.nil? 
    end
  end
  
  def change_property(property_hash)
    property_name = property_hash['name']
    unless property_name.nil?
      idx = property_index_by_name(property_name)
      self.properties[idx] = property_hash unless idx.nil?
    end
  end
  
  def remove_property(property_name)
    idx = property_index_by_name(property_name)
    self.properties.delete_at(idx) unless idx.nil?
  end
  
  def unique_id_property=(property_name)
    unless property_name.nil?
      self.properties ||= []
      if self.properties.size > 0
        self.properties.each do |prop|
          prop.unique_id_property = prop.name == property_name ? true : false
        end
      else
        new_prop = Property.new({'name' => property_name, 'unique_id_property' => true })
        self.properties << new_prop
      end 
    end
  end
  
  def property_index_by_name(property_name)
    prop_pos = nil
    self.properties.each_with_index { |prop, idx| prop_pos = idx if property_name == prop['name'] }
    prop_pos
  end

private
  def generate_identifier
    if !title.blank?
      self['identifier'] = title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
  end

end