class DataModel < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails

  use_database :schema
  unique_id :slug

 ## Views
  # query with DataModel.by_name
  view_by :name
  
  # compound sort keys, query with DataModel.by_uri_and_name
  view_by :uri, :name
  
  # custom map/reduce function, query with DataModel.by_tags :reduce => true
  view_by :tags,
    :map => 
      "function(doc) {
        if (doc['couchrest-type'] == 'DataModel' && doc.tags) {
          doc.tags.forEach(function(tag){
            emit(tag, 1);
          });
        }
      }",
    :reduce => 
      "function(keys, values, rereduce) {
        return sum(values);
      }"

  property :name, :length => 1...20
  property :property_list, :cast_as => ["PropertyDefinition"] # syntax to cast an array of instances 
  property :metadata, :cast_as => 'DcesMetadata'
  property :uri, :type => String
  property :tags, :cast_as => ['String']
  property :contact, :cast_as => 'Contact'
  property :slug, :read_only => true

  timestamps!
  
  validates_presence_of :name
  
  set_callback :save, :before, :generate_slug_from_name

  def generate_slug_from_name
    self['slug'] = name.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
end