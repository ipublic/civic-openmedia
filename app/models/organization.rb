class Organization < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails
  require 'contact'
  require 'address'
  include CouchRest::Validation
  
  use_database :community
  unique_id :identifier
  
#  attr_accessor :url
  
  property :name, :length => 1...50
  property :abbreviation
  property :identifier, :length => 1...100
  property :points_of_contact, :cast_as => ['Contact'], :default => []
  property :addresses, :cast_as => ['Address'] #, :default => []
  property :website_url
  property :description
  timestamps!

  ## Validations
  validates_presence_of :name
  set_callback :save, :before, :generate_identifier
  
  ## CouchDB Views
  # query with Organization.by_name
  view_by :name
  view_by :name, :identifier
  
  def get_creator_datasets
    list = Dataset.by_creator_organization_id(:key => self['identifier']) # unless new?
  end

private
  def generate_identifier
    unless abbreviation.blank? 
      self['identifier'] = self.class.to_s.pluralize.downcase + '_'+ abbreviation.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    else
      self['identifier'] = self.class.to_s.pluralize.downcase + '_'+ name.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
#    self['identifier'] = name.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
  def generate_contact_fullname
    self.point_of_contact['full_name'] = self.point_of_contact['first_name'] + ' ' + self.point_of_contact['last_name']
  end
  
end

