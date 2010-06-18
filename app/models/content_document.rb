class ContentDocument < CouchRestRails::Document
  
  require 'property'
  require 'metadata'
  require 'data_filter'

  ## CouchDB database and record key
  use_database :community
  unique_id :identifier
  
  ## Properties
  property :title
  property :identifier
#  property :uri
  property :properties, :cast_as => ["Property"], :default => [] 
  property :metadata, :cast_as => 'Metadata'
  property :filters, :cast_as => ['Filter']
  
  timestamps!

  ## Validations
#  validates_presence_of :title
#  validates_with_method :identifier, :method => :id_is_unique

  ## Callbacks
  before_save :generate_identifier
#  before_save :id_is_unique
  
  ## Views
  view_by :title

  view_by :creator_organization_id, {
          :map => 
            "function(doc) { 
              if ((doc['couchrest-type'] == 'ContentDocument') && doc['metadata'] && doc['metadata']['creator_organization_id']) 
                { emit(doc['metadata']['creator_organization_id'], doc['_id'], 1);  
                }
              }",
          :reduce => 
            "function(keys, values, rereduce) { 
              return values;
            }" 
          }
  
  # view_by :keywords,
  #   :map => 
  #     "function(doc) {
  #       if ((doc['couchrest-type'] == 'Content') && doc['metadata'] && doc['metadata']['keywords']) {
  #         doc['metadata']['keywords'].forEach(function(keyword){
  #           emit(keyword, 1);
  #         });
  #       }
  #     }",
  #   :reduce => 
  #     "function(keys, values, rereduce) {
  #       return sum(values);
  #     }"  
  # 

  def get_creator_organization
    org = Organization.get(self.metadata.creator_organization_id) unless self.metadata.creator_organization_id.blank?
  end
  
  def get_maintainer_organization
    org = Organization.get(self.metadata.maintainer_organization_id) unless self.metadata.maintainer_organization_id.blank?
  end
  
  def get_publisher_organization
    org = Organization.get(self.metadata.publisher_organization_id) unless self.metadata.publisher_organization_id.blank?
  end

private
  def generate_identifier
    unless title.blank?
      self['identifier'] = title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
  end
  
  def id_is_unique
    if self.by_title(:key => self.title, :limit => 1).blank? || self.get("#{self.id}").title == self.title
      return true
    else
      return [false, "Content Document by this title already exists"]
    end
  end
  
  
end
