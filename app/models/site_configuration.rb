class SiteConfiguration < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails

  use_database :site_configuration

  property :name

  timestamps!
end