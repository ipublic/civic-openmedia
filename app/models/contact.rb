class Contact < Hash
  
  include CouchRest::CastedModel
  include CouchRest::Validation
  require 'address'

  property :first_name
  property :last_name
  property :job_title
  property :phone
  property :email
  property :website_url
  property :address, :cast_as => 'Address'
  
#  property :addresses, :cast_as => ['Address'] # support multiple addresses for contact
  property :note

end