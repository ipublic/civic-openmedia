class Contact < CouchRestRails::Document

  require 'address'

  use_database :site

  property :first_name
  property :last_name
  property :job_title
  property :phone
  property :email
  property :website_url
  property :address, :cast_as => 'Address'
#  property :addresses, :cast_as => ['Address'] # support multiple addresses for contact
  property :note

  timestamps!

  ## Validations
  validates_presence_of :first_name, :last_name
  
  ## CouchDB Views
  # query with Organization.by_name
  view_by :last_name, :first_name
  view_by :first_name, :last_name

end