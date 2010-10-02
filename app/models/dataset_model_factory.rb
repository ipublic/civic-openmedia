class DatasetModelFactory
  require "dataset_template"  # provides a few basic properties
  
  attr_reader :name, :class_name
  
  def initialize(name)
    @name = name.to_s
    @class_name = string_to_class(@name)
    document_class
  end
  
  def string_to_class(str)
    str = str.to_s.rstrip.downcase.gsub(/\b\w/) {|first| first.upcase }
    @class_name = str.gsub(/[^A-Za-z0-9]/,'')
  end

  def unique_serial_number
    # Generate unique import serial number from MD5 hash of current date + random number
    require 'md5'
    MD5.md5(Time.now.to_s + rand.to_s).to_s
  end

  def document_class
    if !Object::const_defined? @class_name
#      xdoc_class = Object::const_set(@class_name.intern, Class::new(super_class=CouchRest::ExtendedDocument))
      fac_class = Object::const_set(@class_name.intern, Class::new(super_class=DatasetTemplate))
    else
      fac_class = Object::const_get(@class_name)
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


   
  def load_attachment
    require 'ruport'

    # TODO - recode to handle multiple attachments
    att_name = self['_attachments'].keys[0]
    
    xtab = Ruport::Data::Table.parse(
        self.fetch_attachment(att_name),
        :has_names => self.column_header_row,
        :csv_options => { :col_sep => self.delimiter_character }
      )
    
    series_id = unique_serial_number
    time_stamp = Time.now.to_json
    
    # Append administrative properties
    xtab.add_column("updated_at", :default => time_stamp, :position => 1)
    xtab.add_column("created_at", :default => time_stamp, :position => 1)
    xtab.add_column("series_id", :default => series_id, :position => 1)
    xtab.add_column(COUCHREST_TYPE_PROPERTY_NAME, :default => self.identifier, :position => 1)

    # Write the column names 
    xtab.column_names.each { |col_name| add_property Property.new(:name => col_name) }

    # Write attachment records to CouchDB docs
    xtab.each do |row|
      rs = self.database.bulk_save_doc(row.data)
    end
    self.database.bulk_save
  end
  

end