class Address < CouchRestRails::Document
  
  use_database :catalog
#  unique_id :slug
  
  
  ## Properties
  property :full_address
  property :premise_name
  property :premise_number_prefix
  property :premise_number
  property :premise_number_suffix
  property :sub_premise
  property :street_number_prefix
  property :street_number
  property :street_number_suffix
  property :street_pre_direction
  property :street_name
  property :street_post_direction
  property :city
  property :county, :cast_as => 'County'
  property :state, :cast_as => 'State'
  property :zipcode
  
  property :coordinate, :cast_as => 'Coordinate'
  property :valid_from_date, :type => Date
  property :valid_to_date, :type => Date
  
  timestamps!

  set_callback :save, :before, :generate_full_address

  ## Validations
  validates_presence_of [:street_name, :city, :state]
  

  def generate_full_address
    address_str << "#{premise_name}, " if premise_name
    address_str << "#{premise_number_prefix}, " if premise_number_prefix
    address_str << "#{premise_number}, " if premise_number
    address_str << "#{premise_number_suffix}, " if premise_number_suffix
    address_str << "#{sub_premise}, " if sub_premise
    address_str << "#{street_number_prefix}, " if street_number_prefix
    address_str << "#{street_number}, " if street_number
    address_str << "#{street_number_suffix}, " if street_number_suffix
    address_str << "#{street_pre_direction}, " if street_pre_direction
    address_str << "#{street_name}, " if street_name
    address_str << "#{street_post_direction}, " if street_post_direction
    address_str << "#{city}, " if city_name
    address_str << "#{state.abbreviation}" if state.abbreviation
    address_str << "#{zipcode}" if zipcode

    self['full_address'] = address_str
  end
  
end

