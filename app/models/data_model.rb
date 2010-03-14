class DataModel < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails
  require 'property_definition'
  require 'dces_metadata'
  include CouchRest::Validation

  use_database :schema
  unique_id :uri

  property :name, :length => 1...20
  property :property_definitions, :cast_as => ['PropertyDefinition'], :default => [] # syntax to cast an array of instances 
  property :metadata, :cast_as => 'DcesMetadata', :default => []
  property :tags, :cast_as => ['String'], :default => []
#  property :contact, :cast_as => 'Contact'
  property :uri, :read_only => true

  timestamps!
  
  validates_presence_of :name
  set_callback :save, :before, :generate_uri

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

=begin
  TODO Prepend canonical_url from site to make name unique
=end
  def generate_uri
    self['uri'] = name.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
  def new_property_definition_attributes=(property_definition_attributes)
    property_definition_attributes.each do |attributes|
      property_definition.build(attributes)
    end
  end
  
  def existing_property_definition_attributes=(property_definition_attributes)
    tasks.reject(&:new_record?).each do |task|
      attributes = task_attributes[task.id.to_s]
      if attributes
        task.attributes = attributes
      else
        tasks.delete(task)
      end
    end
  end
  
  # def save_tasks
  #   tasks.each do |task|
  #     task.save(false)
  #   end
  # end
  
end