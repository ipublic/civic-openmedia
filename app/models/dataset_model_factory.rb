class DatasetModelFactory
  require "dataset_template"
  
  attr_accessor :database
  attr_reader :name, :class_name, :design_doc_id
  
  def name=(name_str)
    @class_name = string_to_class(name_str)
    design_doc_id
    @name = name_str
  end
  
  def design_doc_id
    "_design/#{@class_name}"
  end

  def create_design_doc
    raise ArgumentError, "#{self.class.name.to_s} requires a name" unless @class_name && @class_name.length > 0
    raise ArgumentError, "#{self.class.name.to_s} requires a database" unless self.database
    
    doc = default_design_doc
    doc["_id"] = design_doc_id

    saved = database.get(doc["_id"]) rescue nil
    resp = database.save_doc(doc) unless saved
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
            if (doc['couchrest-type'] == '#{@class_name.to_s}') {
              emit(doc['_id'],1);
            }
          }"
        }
      }
    }
  end
  
  def string_to_class(str)
    str = str.to_s.rstrip.downcase.gsub(/\b\w/) {|first| first.upcase }
    @class_name = str.gsub(/[^A-Za-z0-9]/,'')
  end

  def document_class
    raise ArgumentError, "#{self.class.name.to_s} requires a name" unless @class_name && @class_name.length > 0

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
  

end