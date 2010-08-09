class Contact < Hash
#class Contact < CouchRestRails::Document

  require 'address'
  require 'phone'

  include ::CouchRest::CastedModel
  include Validatable

#  use_database :site
#  unique_id :email

  property :first_name
  property :last_name
  property :job_title
  property :email
  property :website_url
  property :phones, :cast_as => ['Phone']
  property :addresses, :cast_as => ['Address']
  property :note

  #  property :organization_id
  # timestamps!

  ## Validations
  # specifyied as unique_id, email is automatically included in validation 
  
  ## CouchDB Views
  # query with Contact.by_last_name_and_first_name
  # view_by :last_name, :first_name
  # view_by :first_name, :last_name
  # view_by :organization_name
  # view_by :name, :email

end