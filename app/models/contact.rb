class Contact < Hash
  
  include ::CouchRest::CastedModel
  include Validatable
  require 'address'

  property :full_name
  property :first_name
  property :last_name, :alias => :family_name
  property :job_title
  property :phone
  property :email
  property :website_url
  
  property :addresses, :cast_as => ['Address'] # support multiple addresses for contact
  property :notes

end