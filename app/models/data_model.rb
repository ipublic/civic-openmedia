class DataModel < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails
  require 'property_definition'
  require 'dces_metadata'
  include CouchRest::Validation

  use_database :schema
  unique_id :identifier
  attr_accessor :identifier
  

  property :identifier, :read_only => true
  property :title, :alias => :name, :length => 1...20
  property :metadata, :cast_as => 'DcesMetadata', :default => []
  property :property_definitions, :cast_as => ['PropertyDefinition'], :default => [] # syntax to cast an array of instances 
#  property :contact, :cast_as => 'Contact'

  timestamps!
  
  validates_presence_of :title
  set_callback :save, :before, :generate_identifier

  ## Views
   # query with DataModel.by_name
   view_by :title

   # compound sort keys, query with DataModel.by_uri_and_name
   view_by :identifier, :title

   # custom map/reduce function, query with DataModel.by_tags :reduce => true
   view_by :tags,
     :map => 
       "function(doc) {
         if (doc['couchrest-type'] == 'DataModel' && doc.metadata.subject) {
           doc.metadata.subject.forEach(function(subject){
             emit(subject, 1);
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
  def generate_identifier
    self['identifier'] = title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
  def new_property_definition_attributes=(property_definition_attributes)
    property_definition_attributes.each do |attributes|
      self.property_definitions << attributes
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