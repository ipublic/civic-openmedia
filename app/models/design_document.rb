class DesignDocument < CouchRest::Design
  
#   def self.new(raw_name, couch_database)  
#     dd_name = string_to_class_name(raw_name)
#   
#     if !Object::const_defined? dd_name
#       xdoc_class = Object::const_set(dd_name.intern, Class::new(super_class=CouchRest::ExtendedDocument))
#     else
#       xdoc_class = Object::const_get(dd_name)
#     end
#   
#     dd = xdoc_class.design_doc
#     dd.name = dd_name if dd.name.blank?
#     
#     saved = couch_database.get(dd['_id']) rescue nil
#     xdoc_class.save_design_doc_on couch_database unless saved
# #    dd
#     xdoc_class
#   end

  def extended_doc_class
    raise ArgumentError, "_design docs require a name" unless self.name && self.name.length > 0
    if !Object::const_defined? self.name
      xdoc_class = Object::const_set(self.name.intern, Class::new(super_class=CouchRest::ExtendedDocument))
    else
      xdoc_class = Object::const_get(self.name)
    end
  end
  
=begin
  TODO Change anonymous class handling
  ### Setting constants at runtime in Ruby impacts performance
  ### Following is code suggested in CouchRest Google group for managing anonymous ExtendedDocument classes
    # classes = Hash.new do |classes, name|
    #   klass = Class.new(CouchRest::ExtendedDocument)
    #   des.database = couch_database
    #   ...
    #   classes[name] = klass
    # end
    # 
  #  Then when the hash doesn't have the value, it'll create a new class on
  #  demand. If it does, it'll just fetch it and return it

    # classes['whatever'].property :a_new_property
    # classes['whatever'].new #=> a new instance of that class
=end
  
  def save
    raise ArgumentError, "_design docs require a name" unless self.name && self.name.length > 0
#    raise ArgumentError, "_design docs require a database" unless self.database && !self.database.nil?

    dd = extended_doc_class.design_doc
    dd.name = self.name if dd.name.blank?
    saved = self.database.get(dd['_id']) rescue nil
    unless saved
      xdoc_class = extended_doc_class
      xdoc_class.database = self.database
      res = xdoc_class.save_design_doc_on self.database
    else
      super
    end
  end
  
  def default_properties
    # import_series string, created_at date, updated_at date
  end
   
  # def self.new(raw_name, target_db)
  # 
  #   dd_name = string_to_class_name(raw_name)
  # 
  #   # if !Object::const_defined? dd_name
  #   #   xdoc_class = Object::const_set(dd_name.intern, Class::new(super_class=CouchRest::ExtendedDocument))
  #   # else
  #   #   xdoc_class = Object::const_get(dd_name)
  #   # end
  # 
  #   xdoc_classes = Hash.new do |xdoc_classes, dd_name|
  #     klass = Class.new(CouchRest::ExtendedDocument)
  #     xdoc_classes[dd_name] = klass
  #   end
  # 
  #   dd = xdoc_classes[dd_name].design_doc
  #   dd.name = dd_name if dd.name.blank?
  #   
  #   saved = target_db.get(dd['_id']) rescue nil
  #   xdoc_classes[dd_name].save_design_doc_on target_db unless saved
  #   dd
  #   xdoc_classes
  # end
  

  def string_to_class_name(str)
    class_name = str.to_s.rstrip.downcase.gsub(/\b\w/) {|first| first.upcase }
    class_name = class_name.gsub(/[^A-Za-z0-9]/,'')
  end

  # Manage Properties
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
  

end