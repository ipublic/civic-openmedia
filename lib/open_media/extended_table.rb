module OpenMedia
  require "ruport"
  
  OPENMEDIA_SERVER = CouchRest.new
  OPENMEDIA_DB = OPENMEDIA_SERVER.database("ipublic_org_site_test")

  COUCHREST_PROPERTY_NAME_TYPE = 'couchrest-type'
  COUCHREST_PROPERTY_NAME_ID = '_id'
  
  class ExtendedTable < Ruport::Data::Table

    # @tbl_in = Ruport::Data::Table.load("#{RAILS_ROOT}/db/crime_incidents_current_csv.csv")
    # e = OpenMedia::ExtendedTable.load("#{RAILS_ROOT}/db/crime_incidents_current_csv.csv")
    def to_content_document
      doc = ContentDocument.new
      self.column_names.each do |col_name|
        doc.properties << Property.new(:name => col_name)
      end
      doc
    end
    
    def add_column_couchrest_type(dataset_name)
      if !dataset_name.blank? && self.column_names.find_index(COUCHREST_PROPERTY_NAME_TYPE).nil?
        self.add_column(COUCHREST_PROPERTY_NAME_TYPE, :position => 1) { |ds| ds = dataset_name }  
      end
    end
    
    # Assign a unique database key
    def add_column_couchrest_id(key_column)
      if self.column_names.find_index(COUCHREST_PROPERTY_NAME_ID).nil?
        if !key_column.blank?
          self.add_column(COUCHREST_PROPERTY_NAME_ID, :position => 1) { |r| r.get(key_column) }
        # else
        #   #TODO capability to reference counter variable
        #   self.add_column(COUCHREST_PROPERTY_NAME_ID, :position => 1) 
        end
      end
    end
    
    def save
      # TODO - Correct database reference
      @db = OPENMEDIA_DB

      # TODO - Report number of successful saves and conflicts
      self.each do |row|
        rs = @db.bulk_save_doc(row.data)
      end
      @db.bulk_save
    end

    def dummy
      # This code uses Ruport library to access CSV files and import content into CouchDB records
  
      # Load CSV file with headers
      @tbl_in = Ruport::Data::Table.load("#{RAILS_ROOT}/db/crime_incidents_current_csv.csv")
      @cols = @tbl_in.column_names
      @vals = @tbl_in.data
  
      # Select one column as primary key - should support > 1
      @key = [@cols[0]]

      # Create or connect to CouchDB database
      @db = CouchRest.database!("http://127.0.0.1:5984/openmedia-test")

      ## Should we use CouchRest::Document or CouchRest::ExtendedDocument?
      # http://rdoc.info/projects/couchrest/couchrest

      # Transfer column headings
      @prop_list = []
      @cols.each do |name|
        @prop_list << CouchRest::Property.new(name)
      end
  
      # CSV records add/update CouchDB documents
      count = 0
      @vals.each do |rec|
        # Assign unique_id
        # Should prepend content class to keep keys unique across CouchDB
        rec.data['_id'] = rec.data[@key.to_s]
        response = @db.save_doc(rec.data)
        count += 1
      end
      puts count
  
      #Sample CouchRest View
      # @db.save_doc({
      #   "_id" => "_design/first", 
      #   :views => {
      #     :test => {
      #       :map => "function(doc){for(var w in doc){ if(!w.match(/^_/))emit(w,doc[w])}}"
      #       }
      #     }
      #   })
      # puts @db.view('first/test')['rows'].inspect 
  
  
      # Ruport provides filter and transform options for Table class.  Use this and other functions 
      # shape and filter documents 

      # Table.new options include :data, :column_names, :filters, :transforms, :record_class
      @tbl_out = Ruport::Data::Table.new()
  
      # VirtualExtendedDocument is based upon CouchRestRails::ExtendedDocument with following extensions:
      # Houses document definition in a CouchDB database
      # Supports properties, callbacks(?), CouchDB views 
      # Adds metadata properties
      # Adds domain lookups
      # Adds standard transforms: geocode, geocode-block-of
    end
  end
end