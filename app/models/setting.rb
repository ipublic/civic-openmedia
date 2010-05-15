class Setting < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails
  include CouchRest::Validation
  
  use_database :site
  unique_id :identifier
  
  property :identifier, :length => 1...100
  property :website_url
  property :description
  timestamps!

  ## Validations
  validates_presence_of :website_url
  set_callback :save, :before, :generate_identifier
  
  ## CouchDB Views
  
private
  def generate_identifier
      self['identifier'] = self['couchrest-type'].to_s.pluralize.downcase + '_'+ website_url.rstrip.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
  end
  
end

