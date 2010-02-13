class Contact < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails

  use_database :schema

  validates_presence_of :first_name

  property :first_name
  property :last_name, :alias => :family_name
  property :job_title
  property :phone, :cast_as => 'Phone'
  property :email
  property :organization, :cast_as => 'Organization'
  property :address, :cast_as => 'Address'
  property :notes
  timestamps!
  
  view_by :first_name
  
end