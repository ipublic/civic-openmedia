require 'spec_helper'

describe DatasetModelFactory do
  before(:all) do
    reset_test_db!
  end

  describe "Instantiate CouchRest ExtendedDocument class" do
    before(:each) do
      @db = reset_test_db!
    end

    it "should return an anonymous class with passed name" do
      @dmf = DatasetModelFactory.new("Movies")
      fac_doc = @dmf.document_class
      fac_doc.should be_an_instance_of(Class)
      fac_doc.name.to_s == "Movies"
    end

    it "should create an instance of type: class_name" do
      @dmf = DatasetModelFactory.new("Movies")
      klass_name = @dmf.class_name
      fac_doc = @dmf.document_class
      xdoc = fac_doc.new
      xdoc["couchrest-type"].should == klass_name
    end
  end

  describe "Instantiate CouchRest ExtendedDocument class" do
    it "should generate unique serial numbers" do
      @dmf = DatasetModelFactory.new("Movies")
      sn = @dmf.unique_serial_number
      @dmf.unique_serial_number.to_s.should_not == sn.to_s
    end
  end
end
