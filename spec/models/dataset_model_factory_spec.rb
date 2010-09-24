require 'spec_helper'

describe DatasetModelFactory do
  before(:all) do
    reset_test_db!
  end

  describe "Create CouchDB Design Document for Dataset" do
    before(:each) do
      @db = reset_test_db!
      @dmf = DatasetModelFactory.new
    end
    
    it "should fail without a name" do
      lambda{@dmf.create_design_doc.should}.should raise_error(ArgumentError)
    end
    
    it "should fail without a database" do
      @dmf.name = "movies"
      lambda{@dmf.create_design_doc.should}.should raise_error(ArgumentError)
    end
    
    it "should save design document with identifier" do
      @dmf.name = "movies"
      @dmf.database = @db
      @dd_id = @dmf.design_doc_id
      resp = @dmf.create_design_doc
      resp["id"].should == @dd_id
    end

    it "should return nil if design document already exists" do
      @dmf.name = "movies"
      @dmf.database = @db
      @dd_id = @dmf.design_doc_id
      @dmf.create_design_doc
      @dmf.create_design_doc.should == nil
    end
  end
    
  describe "Instantiate CouchRest ExtendedDocument class" do
    before(:each) do
      @db = reset_test_db!
      @dmf = DatasetModelFactory.new
    end

    it "should fail without a name" do
      lambda{@dmf.document_class}.should raise_error(ArgumentError)
    end

    it "should return an anonymous class with passed name" do
      @dmf.name = "movies"
      fac_doc = @dmf.document_class
      fac_doc.should be_an_instance_of(Class)
      fac_doc.name.to_s == "Movies"
    end

    it "should create an instance of type: class_name" do
      @dmf.name = "movies"
      klass_name = @dmf.class_name
      fac_doc = @dmf.document_class
      xdoc = fac_doc.new
      xdoc["couchrest-type"].should == klass_name
    end
  end

  # describe "Dataset properties" do
  #   before(:each) do
  #     @ds = Dataset.new(:title => "movies")
  #     @ds.database = DB
  #     @prop = Property.new({"name"=>"genre", "default_value" => "Action"})
  #     @prop_update = Property.new({"name"=>"genre", "default_value" => "Horror"})
  #     @prop_without_name = Property.new()
  #   end
  # 
  #   it "should not accept a property without name attribute" do
  #     @ds.add_property(@prop_without_name).should == nil
  #   end
  #   
  #   it "should add a property" do
  #     @ds.add_property(@prop)
  #     @ds['properties'][0]['name'].should =="genre"
  #   end
  #   
  #   it "should not add a duplicate property" do
  #     @ds.add_property(@prop)
  #     @ds.add_property(@prop).should == nil
  #   end
  #   
  #   it "should change a property" do
  #     @ds.add_property(@prop)
  #     @ds.properties[0]['default_value'] == "Action"
  #     @ds.change_property(@prop_update)
  #     @ds.properties[0]['default_value'] == "Horror"
  #   end
  #   
  #   it "should remove a property" do
  #     @ds.add_property(@prop)
  #     @ds['properties'].size == 1
  #     @ds.remove_property(@prop)
  #     @ds['properties'].size == 0
  #   end
  #   
  #   it "should not find index of an absent property" do
  #     @ds.property_index_by_name('no such property').should == nil
  #   end
  #   
  #   it "should find index of an existing property" do
  #     @ds.add_property(@prop)
  #     @ds.property_index_by_name('genre').should == 0
  #   end
  #   
  # end
  # 
  # describe "unique_id_property=" do
  #   before(:each) do
  #     @ds = Dataset.new(:title => "movies")
  #     @ds.database = DB
  #     @prop = Property.new({"name"=>"genre", "default_value" => "Action"})
  #   end
  # 
  #   it "should set the primary key flag" do
  #     @ds.add_property(@prop)
  #     @ds.unique_id_property = 'genre'
  #     @ds.properties[0]['unique_id_property'].should == true
  #   end
  # end


end
