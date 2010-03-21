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
  property :point_of_contact, :cast_as => 'Contact', :default => []
  property :address, :cast_as => 'Address', :default => []
  property :website_url
  property :description
  timestamps!

  ## Validations
  validates_presence_of :name
  set_callback :save, :before, :generate_identifier
  set_callback :save, :before, :generate_contact_fullname
  
  ## CouchDB Views
  # query with Organization.by_name
  view_by :name

  ## This constant assignment will throw error when DB is first initialized 
  ## (until model views are loaded to CouchDB)
    NAMES_IDS = self.all.map do |m|
      [m.name, m.identifier]
    end  
  
private
  def generate_identifier
    unless abbreviation.blank? 
      self['identifier'] = self['couchrest-type'].to_s.pluralize.downcase + '_'+ abbreviation.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    else
      self['identifier'] = self['couchrest-type'].to_s.pluralize.downcase + '_'+ name.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
#    self['identifier'] = name.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
  def generate_contact_fullname
    self.point_of_contact['full_name'] = self.point_of_contact['first_name'] + ' ' + self.point_of_contact['last_name']
  end
  
end

