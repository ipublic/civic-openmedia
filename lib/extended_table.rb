module OpenMedia
  require "ruport"
  
  class ExtendedTable < Ruport::Data::Table

    # e = OpenMedia::ExtendedTable.load("#{RAILS_ROOT}/db/crime_incidents_current_csv.csv")
    # template = e.to_template
    def to_content_document
      doc = ContentDocument.new
      self.column_names.each do |col_name|
        doc.properties << Property.new(:name => col_name)
      end
      doc
    end
    
    def save
      if self.data.count < 1000
        
        self.data.each do |row|
          doc = Doc.new(row.data)

          row.data.each do |prop_name, value|
            puts prop_name
            puts value
          end
        end
      end
      
      # if record count > 1000, use bulk save method
      
    end
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