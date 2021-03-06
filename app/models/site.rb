class Site < CouchRestRails::Document

  require 'gnis'
  require 'contact'

  DATABASE_NAMES = ["site", "staging", "public", "community"]

#  include CouchRest::Validation
  
  use_database :site
  unique_id :identifier
  
  ## Property Definitions
  # General properties
  property :identifier,  :read_only => true
  property :url
  property :openmedia_name, :default => "Civic OpenMedia"
  property :adminstrator_contact_id, :cast_as => 'Contact'
  property :business_contact_id, :cast_as => 'Contact'
  
  # Administration properties
  property :internal_couchdb_server_uri, :default => "http://localhost:5984"
  property :public_couchdb_server_uri, :default => "http://localhost:5984"
  property :replicate_community_catalog
  
  # Location properties
  property :gnis, :cast_as => 'Gnis', :default => [] # e.g.; 584282 for Ellicott City, MD
  
  property :site_domain_name
  property :site_proxy_prefix
  property :site_canonical_url, :default => "http://localhost"
  property :site_organization_id
  property :site_default_city
  property :site_default_state
  
  property :catalogs, :cast_as => ['Catalog']

  # Services properties
  # Default googlemap_api_key is for http://localhost
  property :googlemap_api_key, :default => "ABQIAAAALBip6RF6CeNkMG5FsLJfjRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxRnUJ7zjI2v5FZxVYW7aoB2EAT8hQ"
  
  timestamps!

  ## Validations
  validates_presence_of :url

  ## Callbacks
  before_save :generate_identifier
  
  ## CouchDB Views
  # singleton class - no views

private
  def generate_identifier
    if !url.blank?
      self['identifier'] = url.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    end
  end
  
end

