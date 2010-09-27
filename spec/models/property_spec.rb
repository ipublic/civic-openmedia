describe Property do

  describe "managing properties" do
    before(:each) do
      @prop = Property.new("Title", "string", 
        :is_key => true, 
        :can_query => false, 
        :definition => "Movie name",
        :default_value => "Unknown",
        :example_value => "The Matrix",
        :comment => "this is a comment"
      )
    end
    
    it "should return saved values for all attributes" do
      @prop.should be_instance_of(Property)
      @prop.name.should == "Title"
      @prop.type.should == "string"
      @prop.is_key.should == true
      @prop.definition.should == "Movie name"
      @prop.can_query.should == false
      @prop.default_value.should == "Unknown"
      @prop.example_value.should == "The Matrix"
      @prop.comment.should == "this is a comment"
    end
  
    it "should output all attributes in hash format" do
      hash_val = @prop.to_hash
      hash_val["name"].should == "Title"
      hash_val["type"].should == "string"
      hash_val["is_key"].should == true
      hash_val["definition"].should == "Movie name"
      hash_val["can_query"].should == false
      hash_val["default_value"].should == "Unknown"
      hash_val["example_value"].should == "The Matrix"
      hash_val["comment"].should == "this is a comment"
    end
  end
end
