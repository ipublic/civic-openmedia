class Setting < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails
  include CouchRest::Validation
  
  use_database :site
  unique_id :identifier
  
  ## Property Definitions
  property :identifier
  property :admin_couchdb_server, :default => "http://localhost:5984"
  property :public_couchdb_server, :default => "http://localhost:5984"
  
  property :site_name, :default => "Civic OpenMedia"
  property :site_domain_name
  property :site_proxy_prefix
  property :site_canonical_url, :default => "http://pubdata.changeme.gov/"
  property :site_organization_id

  # Default googlemap_api_key is for http://localhost
  property :googlemap_api_key, :default => "ABQIAAAALBip6RF6CeNkMG5FsLJfjRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxRnUJ7zjI2v5FZxVYW7aoB2EAT8hQ"
  
  timestamps!

  ## Validations
  validates_presence_of :site_domain_name

  ## Callbacks
  before_save :generate_identifier
  
  ## CouchDB Views
  
private
  def generate_identifier
      self['identifier'] = self.class.to_s.pluralize.downcase + '_'+ site_domain_name.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
end

