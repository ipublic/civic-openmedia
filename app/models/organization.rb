class Organization < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails
  require 'phone'
  require 'address'
  require 'contact'
  
  use_database :site
  unique_id :identifier 

  property :name
  property :identifier
  property :abbreviation
  property :email
  property :website_url
  property :phones, :cast_as => ['Phone']
  property :addresses, :cast_as => ['Address']
  property :contacts, :cast_as => ['Contact']
  property :note
  
  # TODO: Add ability to upload agency logo 
  timestamps!

  ## Validations
  validates_presence_of :name
  
  ## Callbacks
  before_save :generate_identifier
  
  ## CouchDB Views
  # query with Organization.by_name
  view_by :name
  view_by :abbreviation
  view_by :name, :identifier
  
  def get_creator_content_documents
    list = ContentDocument.by_creator_organization_id(:key => self['identifier']) # unless new?
  end

private
  def generate_identifier
    unless abbreviation.blank? 
      self['identifier'] = self.class.to_s.downcase + '_' + abbreviation.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    else
      self['identifier'] = self.class.to_s.downcase + '_' + name.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
#    self['identifier'] = name.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
end

