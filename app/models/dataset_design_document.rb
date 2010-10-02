class DatasetDesignDocument < CouchRest::Design
  
# Manage Properties

  # def default_properties
  #   prop_list = []
  #   %w{import_series created_at updated_at}.each do |prop_name|
  #     prop_list << CouchRest::Property.new({"name"=>prop_name})
  #   end
  #   prop_list
  # end
  
  attr_accessor :doc, :database
  attr_reader :name, :class_name, :property_list, :design_doc_id
  
  def initialize
    clear_property_list
  end
  
  def name=(name)
    @name = name.to_s
    @class_name = string_to_class(@name)
    design_doc_id
  end
  
  def property_list
    @property_list.inject([]) {|props, next_prop| props << next_prop.to_hash }
  end

  def doc 
    @doc = default_design_doc
  end
  
  def design_doc_id
    "_design/#{class_name}" 
  end

  def default_design_doc
    time_stamp = Time.now.to_json

    {
      "language" => "javascript",
      "metadata" => {
        'type' => 'Dataset',
        'language' => 'en-US',
        'created_date' => time_stamp,
        'last_updated' => time_stamp
        },
      "properties" => property_list,
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
    str = str.to_s.rstrip.downcase.gsub(/\b\w/) {|first| first.upcase }
    cname = str.gsub(/[^A-Za-z0-9]/,'')
  end

  def metadata_list
  end
  
  def clear_property_list
    @property_list = []
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
  
  def save
    raise ArgumentError, "#{self.class.name} requires a name" unless @class_name && @class_name.length > 0
    raise ArgumentError, "#{self.class.name} requires a database" unless @database
    
    doc = default_design_doc
    doc["_id"] = design_doc_id

    # saved = database.get(doc["_id"]) rescue nil
    # resp = database.save_doc(doc) unless saved
    @database.save_doc(doc)
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
 
end