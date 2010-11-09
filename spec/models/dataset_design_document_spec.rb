require 'spec_helper'

describe DatasetDesignDocument do
  before(:all) do
    reset_test_db!
  end

  describe "Accessing CouchDB" do
    before(:each) do
      @db = reset_test_db!
      @ddd = DatasetDesignDocument.new(@db)
    end
    
    it "should fail without a name" do
      lambda{@ddd.save.should}.should raise_error(ArgumentError)
    end

    # it "should fail without a database" do
    #   @ddd.name = "movies"
    #   lambda{@ddd.save.should}.should raise_error(ArgumentError)
    # end

    it "should save design document with identifier" do
      @ddd.name = "movies"
      @ddd.database = @db
      dd_id = @ddd.design_doc_id
      resp = @ddd.save
      resp["id"].should == dd_id
    end

    it "should raise error if design document already exists" do
      @ddd.name = "movies"
      @ddd.database = @db
      dd_id = @ddd.design_doc_id
      @ddd.save
      lambda{@ddd.save.should}.should raise_error
    end
  end

  describe "managing properties" do
    before(:each) do
      @db = reset_test_db!
      @ddd = DatasetDesignDocument.new(@db)
      @prop0 = Property.new("Title", :type => "string", :is_key => true)
      @prop1 = Property.new("Category", :type => "string", :is_key => false, :example_value => "Science Fiction")
      @prop2 = Property.new("Rating", :type => "string", :example_value => "R")
    end
    
    it "should clear all properties" do
      @ddd.add_property @prop0
      @ddd.clear_property_list.should == []
    end

    it "should add and return a property by name" do
      @ddd.add_property @prop0
      rtn_prop = @ddd.get_property(@prop0.name)
      rtn_prop.name.should == @prop0.name
    end
    
    it "should return nil for a property that doesn't exist" do
      @ddd.clear_property_list
      @ddd.add_property @prop0
      @ddd.get_property(@prop1.name).should == nil
    end

    it "should remove a property by name" do
      @ddd.clear_property_list.should == []
      @ddd.add_property @prop0
      rtn_prop = @ddd.get_property(@prop0.name)
      rtn_prop.name.should == @prop0.name
      
      @ddd.delete_property(@prop0.name)
      @ddd.get_property(@prop0.name).should == nil
    end

    it "should return all properties as an array of hashes" do
      @ddd.add_property @prop0
      @ddd.add_property @prop1
      @ddd.add_property @prop2
      props = @ddd.property_list
      props.should be_an_instance_of(Array)
      props[0].should be_an_instance_of(Hash)
    end
  end
end
