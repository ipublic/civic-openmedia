class Dataset < CouchRestRails::Document
  
  include CouchRest::Validation
  
  ## CouchDB database and record key
  use_database :community
  unique_id :dataset_id 
  
  ## Properties
  property :title
  property :uri
  property :dataset_id
  property :properties, :cast_as => ["Property"], :default => [] 
  property :metadata, :cast_as => 'Metadata'
  property :filters, :cast_as => ['Filter']
  
  timestamps!

  ## Validations
#  validates_presence_of :title
  
#  validates_with_method :dataset_id, :method => :id_is_unique


  ## Callbacks
  before_save :generate_dataset_id
  
  ## Views
  view_by :title
  view_by :title, :uri

  # view_by :keywords,
  #   :map => 
  #     "function(doc) {
  #       if ((doc['couchrest-type'] == 'Dataset') && doc['metadata'] && doc['metadata']['keywords']) {
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
  # view_by :creator_organization_id,
  #   :map => 
  #     "function(doc) {
  #       if ((doc['couchrest-type'] == 'Dataset') && doc['metadata'] && doc['metadata']['creator_organization_id']) {
  #           emit(doc['metadata']['creator_organization_id'], 1);
  #       }
  #     }",
    # :reduce => 
    #   "function(keys, values, rereduce) {
    #     return sum(values);
    #   }"  

  def get_creator_organization
    org = Organization.get(self.metadata.creator_organization_id) unless self.metadata.creator_organization_id.blank?
  end

private
  def generate_dataset_id
    #Pattern for Unique ID: "class" + "_" + "key"
    unless title.blank?
      self['dataset_id'] = self.class.to_s.downcase + '_' + title.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
  end
  
#   def id_is_unique
# #    if self.by_title(:key => self.title, :limit => 1).blank? || self.get("#{self.id}").title == self.title
#     if self.get(:key => self.title, :limit => 1).blank? || self.get("#{self.id}").title == self.title
#       return true
#     else
#       return [false, "Dataset by this title already exists"]
#     end
#   end
  
  
end
