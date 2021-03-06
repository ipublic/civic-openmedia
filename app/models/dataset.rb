class Dataset < CouchRestRails::Document
  
#  require 'content_document'
  require 'connection'
  require 'property'
  require 'metadata'

  COUCHREST_TYPE_PROPERTY_NAME = 'couchrest-type'

  ## CouchDB database and record key
  use_database :staging
  unique_id :identifier
  
  ## Properties
  property :identifier
  property :title
  property :catalog_id, :default => "staging"
  property :properties, :cast_as => ["Property"], :default => [] 
  property :metadata, :cast_as => 'Metadata'
  property :import_series  # unique tag assigned for each batch load
  
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
  view_by :import_series
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
  view_by :properties,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'Dataset') && doc['properties'] && doc['properties']['name']) {
          doc['properties']['name'].forEach(function(name){
            emit(name, 1);
          });
        }
      }",
    :reduce => 
      "function(keys, values, rereduce) {
        return sum(values);
      }"  

  view_by :creator_organization_id, {
          :map => 
            "function(doc) { 
              if ((doc['couchrest-type'] == 'Dataset') && doc['metadata'] && doc['metadata']['creator_organization_id']) 
                { emit(doc['metadata']['creator_organization_id'], doc['_id'], 1);  
                }
              }",
          :reduce => 
            "function(keys, values, rereduce) { 
              return values;
            }" 
          }

  ## Callbacks
#  before_save :generate_identifier

  ## Methods
  def self.search(search_str)
    if !search_str.nil?
      by_title(:key => search_str)
    else
      all
    end
  end
  
  def initialize_document
    init_dataset_class
    load_attachment
  end
  
  def init_dataset_class
    return if self.identifier.blank?
    ds_name = self.identifier.to_s.capitalize
    
    # TODO should raise error when attempting to create duplicate dataset name
    return if Object::const_defined? ds_name
    Object::const_set(ds_name.intern, Class::new(super_class=CouchRest::ExtendedDocument))
    
    # Specify database store
    Object::const_get(ds_name).database = self.database
    # Object::const_get(ds_name).view_by 
    Object::const_get(ds_name).save_design_doc

    # Object::const_get(ds_name).property('identifier')
    # Object::const_get(ds_name).property('title')
    # Object::const_get(ds_name).property('catalog_id', {:default => "staging"})
    # Object::const_get(ds_name).property('metadata', {:cast_as => 'Metadata'})
    # Object::const_get(ds_name).property('import_series')

  end
    
  def load_attachment
    require 'ruport'
    require 'md5'

    # TODO - recode to handle multiple attachmentsz
    att_name = self['_attachments'].keys[0]
    
    xtab = Ruport::Data::Table.parse(
        self.fetch_attachment(att_name),
        :has_names => self.column_header_row,
        :csv_options => { :col_sep => self.delimiter_character }
      )
    
    # Generate unique import serial number from MD5 hash of current date + random number
    time_val = Time.new
    import_series = MD5.md5(time_val.to_s + rand.to_s).to_s

    time_stamp = time_val.to_json
    
    # Append administrative properties
    xtab.add_column("updated_at", :default => time_stamp, :position => 1)
    xtab.add_column("created_at", :default => time_stamp, :position => 1)
    xtab.add_column("import_series", :default => import_series, :position => 1)
    xtab.add_column(COUCHREST_TYPE_PROPERTY_NAME, :default => self.identifier, :position => 1)

    # Write the column names 
    xtab.column_names.each { |col_name| add_property Property.new(:name => col_name) }

    # Write attachment records to CouchDB docs
    xtab.each do |row|
      rs = self.database.bulk_save_doc(row.data)
    end
    self.database.bulk_save
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
    return if self.properties.empty?
    return if property_hash.empty?
    unless property_hash['name'].nil?
      idx = property_index_by_name(property_hash['name'])
      return if idx.nil?
      self.properties[idx] = property_hash
    end
  end
  
  def remove_property(property_name)
    return if self.properties.empty?
    return if property_name.empty?
    idx = property_index_by_name(property_name)
    return if idx.nil?
    self.properties.delete_at(idx) 
  end
  
  def unique_id_property
    key_prop = nil
    self.properties.each { |prop| key_prop = prop if prop.unique_id_property == true }
    key_prop
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