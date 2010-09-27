class DatasetDesignDocument < CouchRest::Design
  
# Manage Properties

  # def default_properties
  #   prop_list = []
  #   %w{import_series created_at updated_at}.each do |prop_name|
  #     prop_list << CouchRest::Property.new({"name"=>prop_name})
  #   end
  #   prop_list
  # end
  
  def initialize
    @property_list = []
  end
  
  def doc 
    @doc ||= default_design_doc
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
      "properties" => {
      },
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

  def metadata_list
  end
  
  def property_list
    @property_list ||= []
  end
  
  def clear_property_list
    @property_list = []
  end

  def get_property(property_name)
    idx = property_index_by_name(property_name)
    return_property = @property_list.at(idx) unless idx.nil?
  end  

  def add_property(new_property)
    idx = property_index_by_name(new_property) unless @property_list.empty?
    @property_list << new_property if idx == nil
    @property_list
  end

  def delete_property(property_name)
    return if property_list.empty?
    @property_list.delete_if { |list_prop| list_prop.name == property_name } 
    @property_list ||= []
  end

  def property_index_by_name(property_name)
    prop_pos = nil
    return if @property_list.empty?
    @property_list.each_with_index { |prop, idx| prop_pos = idx if property_name == prop.name }
    prop_pos
  end

  def to_json
    return [] if @property_list.empty?
    # @property_list.each_with_object([]) { |prop| prop.to_hash }
    @property_list.each { |e, arr| arr << e.to_hash }
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