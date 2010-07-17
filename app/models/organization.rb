class Organization < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails
  require 'contact'
  require 'address'
  
  use_database :site

  property :name, :length => 1...50
  property :abbreviation
  property :address, :cast_as => 'Address'
  property :contact_id
  property :website_url
  property :note
  
  # TODO: Add ability to upload agency logo 
  timestamps!

  ## Validations
  validates_presence_of :name
  
  ## CouchDB Views
  # query with Organization.by_name
  view_by :name
  view_by :abbreviation
  view_by :contact_id
  
  def get_creator_content_documents
    list = ContentDocument.by_creator_organization_id(:key => self['identifier']) # unless new?
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
  
end

