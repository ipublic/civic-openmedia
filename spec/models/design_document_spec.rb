describe DesignDocument do
  before(:all) do
    reset_test_db!
  end
  
  describe "An unsaved DesignDocument" do
    before(:each) do
      @db = reset_test_db!
      @des = DesignDocument.new
    end
    
    it "should generate an extended doc class of passed name" do
      @des.name = "Movies"
      @des.extended_doc_class.should be_an_instance_of(Class)
      @des.extended_doc_class.name == "Movies"
    end
  
    it "should fail to save if name or dataset values are missing" do
      lambda{@des.save}.should raise_error(ArgumentError, "_design docs require a name")
      
      @des = DesignDocument.new
      @des.database = @db
      # @des.extended_doc_class.should be_an_instance_of(NilClass)
      lambda{@des.save}.should raise_error(ArgumentError, "_design docs require a name")
    end
    
    it "should save a design doc with identifier" do
      @name = "Movies"
      @identifier = %w{"_design/@name"}
      @des.name = @name
      
      @des.database = @db
      @des.save['_id'] == '_design/Movies'
    end
  end

  describe "A saved DesignDocument" do
    before(:each) do
      @db = reset_test_db!
      @des = DesignDocument.new
    end
  
    it "should save a design doc with identifier" do
      # @ds.title = "theater locations"
      # @ds.save
      # @ident = @ds.identifier
      # @ds.create_design_document
      # @db_des = @db.get "_design/" + @ident
      # @db_des.name.should == @ident
    end
  
  end
end