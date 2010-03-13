class Contact < Hash

  include ::CouchRest::CastedModel
  include Validatable

  property :full_name
  property :first_name
  property :last_name, :alias => :family_name
  property :job_title
  property :phone, :cast_as => 'Phone'
  property :email
  property :address, :cast_as => 'Address'
  property :notes

end