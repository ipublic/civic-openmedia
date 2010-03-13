class Organization < CouchRestRails::Document
  
  use_database :site
  unique_id :url
  
  property :name
  property :url
  property :point_of_contact, :cast_as => 'Contact'
  property :description
#  property :org_key

#  set_callback :save, :before, :generate_org_key

  ## Validations
  validates_presence_of :name

  ## CouchDB Views
  # query with Organization.by_name
  view_by :name

  # build key from organization name + contact's email address (if provided)
  # def generate_org_key
  #   org_key << "#{name}-" if name
  #   org_key << "-#{point_of_contact.email}" if point_of_contact.email
  # 
  #   self['org_key'] = org_key
  # end

end

