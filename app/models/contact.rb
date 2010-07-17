class Contact < CouchRestRails::Document

  require 'address'

  use_database :site
  unique_id :email

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
  # specifyied as unique_id, email is automatically included in validation 
  
  ## CouchDB Views
  # query with Organization.by_name
  view_by :last_name, :first_name
  view_by :first_name, :last_name
  view_by :name, :email

end