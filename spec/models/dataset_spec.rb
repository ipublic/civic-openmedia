require 'spec_helper'

describe Dataset do
  before(:all) do
    reset_test_db!
  end

    
  describe "properties" do
    before(:each) do
      @ds = Dataset.new(:title => "movies")
      @ds.database = DB
      @prop = Property.new({"name"=>"genre", "default_value" => "Action"})
      @prop_without_name = Property.new()
      @prop_update = Property.new({"name"=>"genre", "default_value" => "Horror"})
    end

    it "should not accept a property without name attribute" do
      @ds.add_property(@prop_without_name).should == nil
    end
    
    it "should add a property" do
      @ds.add_property(@prop)
      @ds['properties'][0]['name'].should =="genre"
    end
    
    it "should not add a duplicate property" do
      @ds.add_property(@prop)
      @ds.add_property(@prop).should == nil
    end
    
    it "should change a property" do
      @ds.add_property(@prop)
      @ds.properties[0]['default_value'] == "Action"
      @ds.change_property(@prop_update)
      @ds.properties[0]['default_value'] == "Horror"
    end
    
    it "should remove a property" do
      @ds.add_property(@prop)
      @ds['properties'].size == 1
      @ds.remove_property(@prop)
      @ds['properties'].size == 0
    end
    
    it "should not find index of an absent property" do
      @ds.property_index_by_name('no such property').should == nil
    end
    
    it "should find index of an existing property" do
      @ds.add_property(@prop)
      @ds.property_index_by_name('genre').should == 0
    end
    
  end
  
  describe "unique_id_property=" do
    before(:each) do
      @ds = Dataset.new(:title => "movies")
      @ds.database = DB
      @prop = Property.new({"name"=>"genre", "default_value" => "Action"})
    end

    it "should set the primary key flag" do
      @ds.add_property(@prop)
      @ds.unique_id_property = 'genre'
      @ds.properties[0]['unique_id_property'].should == true
    end
  end


end