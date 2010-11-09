class DatasetDesignDocument < CouchRest::Design
  
# Manage Properties

  # def default_properties
  #   prop_list = []
  #   %w{import_series created_at updated_at}.each do |prop_name|
  #     prop_list << CouchRest::Property.new({"name"=>prop_name})
  #   end
  #   prop_list
  # end
  
  # attr_accessor :doc
  attr_reader :name, :class_name, :property_list, :design_doc_id, :database, :doc
  
  ## TODO add default catalog_id argument for staging db
  def initialize(database)
    self.database = database
    clear_property_list
  end
  
  def name=(name)
    @name = name.to_s
    @class_name = string_to_class(@name)
    design_doc_id
  end
  
  def catalog_id=(catalog_id)
#    valid_catalog = Site::DATABASE_NAMES.include?(catalog_id)
    cats = database.catalogs
    valid_catalog = cats.include?(catalog_id)
    raise ArgumentError, "Catalog: '#{catalog_id}' not recognized" unless valid_catalog

    @catalog_id = catalog_id
  end
  
  def catalog_id
    @catalog_id
  end
  
  def design_doc_id
    "_design/#{class_name}" 
  end
  
  def document
    {
      "_id" => design_doc_id,
      "metadata" => metadata,
      "properties" => property_list,
      "catalog_id" => catalog_id,
      "language" => "javascript",
      "views" => {
        'all' => {
          'map' => "function(doc) {
            if (doc['couchrest-type'] == '#{@class_name}') {
              emit(doc['_id'],1);
            }
          }"
        }
      }
    }
  end
  
  def string_to_class(str)
=begin
  TODO verifyt classname generation
=end
#    str = str.to_s.titlecase.gsub(/[[:space:]]/,'') 
    str = str.to_s.rstrip.downcase.gsub(/\b\w/) {|first| first.upcase }
    cname = str.gsub(/[^A-Za-z0-9]/,'')
  end

  def clear_metadata
    @metadata = {}
  end

  def metadata=(metadata)
    raise argumenterror unless metadata.class == Hash
    @metadata = metadata
  end
  
  def metadata 
    @metadata ||= default_metadata
  end
  
  def default_metadata
    date_stamp = Date.today.to_json
    time_stamp = Time.now.to_json
    
    @metadata = {
      'type' => 'Dataset',
      'language' => 'en-US',
      'created_date' => date_stamp,
      'last_updated' => time_stamp
      }
  end
  
  def property_list
    @property_list.inject([]) {|props, next_prop| props << next_prop.to_hash }
  end

  def get_property(property_name)
    idx = property_index_by_name(property_name)
    prop = @property_list.at(idx) unless idx.nil?
  end  

  def add_property(new_property)
    idx = property_index_by_name(new_property) unless @property_list.empty?
    @property_list << new_property if idx == nil
    @property_list
  end

  def delete_property(property_name)
    return if @property_list.empty?
    @property_list.delete_if { |list_prop| list_prop.name == property_name } 
    @property_list ||= []
  end

  def property_index_by_name(property_name)
    prop_pos = nil
    return if @property_list.empty?
    @property_list.each_with_index { |prop, idx| prop_pos = idx if property_name == prop.name }
    prop_pos
  end
  
  def clear_property_list
    @property_list = []
  end

  def save
    raise ArgumentError, "#{self.class.name} requires a name" unless @class_name && @class_name.length > 0
    raise ArgumentError, "#{self.class.name} requires a database" unless @database
    
    # doc = default_design_doc
    # doc["_id"] = design_doc_id

    # saved = database.get(doc["_id"]) rescue nil
    # resp = database.save_doc(doc) unless saved
    @database.save_doc(document)
  end
  
  
  # def unique_id_property
  #   key_prop = nil
  #   self.properties.each { |prop| key_prop = prop if prop.unique_id_property == true }
  #   key_prop
  # end
  # 
  # def unique_id_property=(property_name)
  #   unless property_name.nil?
  #     self.properties ||= []
  #     if self.properties.size > 0
  #       self.properties.each do |prop|
  #         prop.unique_id_property = prop.name == property_name ? true : false
  #       end
  #     else
  #       new_prop = Property.new({'name' => property_name, 'unique_id_property' => true })
  #       self.properties << new_prop
  #     end 
  #   end
  # end
 
  # def generate_identifier
  #   if !title.blank?
  #     self['identifier'] = self.class.to_s.pluralize.downcase + '_' +  title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  #   end
  # end
  # 
  # def id_is_unique?
  #   if self.by_title(:key => self.title, :limit => 1).blank? || self.get("#{self.id}").title == self.title
  #     return true
  #   else
  #     return [false, "Content Document by this title already exists"]
  #   end
  # end
  
end