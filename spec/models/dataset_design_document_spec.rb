describe DatasetDesignDocument do
  before(:all) do
  end

  describe "managing properties" do
    before(:each) do
      @ddd = DatasetDesignDocument.new
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
      props = @ddd.to_json
      props.should be_an_instance_of(Array)
      props[0].should be_an_instance_of(Hash)
    end
  end
end
