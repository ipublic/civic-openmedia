class Address < CouchRestRails::Document
  
  use_database :catalog
  unique_id :uri
  
  include CouchRest::Validation
  
  ## Properties
  property :uri
  property :address_full
  property :premise_full
  property :street_number_full
  property :street_name_full
  
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
  property :state_abbreviation
  property :zipcode
  
  property :coordinate, :cast_as => 'Coordinate'
  property :valid_from_date, :type => Date
  property :valid_to_date, :type => Date
  
  timestamps!

  ## Validations
  validates_presence_of :street_name, :city, :state_abbreviation
#  validates_with_method :address_full, :method => :check_address_uniqueness

  set_callback :save, :before, :generate_full_address
  set_callback :save, :before, :generate_uri
#  set_callback :save, :before, :check_address_uniqueness
  
  ## CouchDB Views
  # query with Organization.by_name
  view_by :street_name_full
  view_by :address_full
  
  def generate_full_address
    puts "generate full address"
    
    premise_str = ''
    premise_str << "#{premise_number_prefix} " if premise_number_prefix
    premise_str << "#{premise_number} " if premise_number
    premise_str << "#{premise_number_suffix} " if premise_number_suffix
    premise_str << "#{sub_premise} " if sub_premise
    
    street_number_str = ''
    street_number_str << "#{street_number_prefix} " if street_number_prefix
    street_number_str << "#{street_number} " if street_number
    street_number_str << "#{street_number_suffix} " if street_number_suffix
    
    street_name_str = ''
    street_name_str << "#{street_pre_direction} " if street_pre_direction
    street_name_str << "#{street_name} " if street_name
    street_name_str << "#{street_post_direction} " if street_post_direction
    
    address_str = ''
#    address_str << premise_str.strip << street_number_str.strip << street_name_str.strip
    address_str << premise_str << street_number_str << street_name_str
    address_str << " #{city}, " if city
    address_str << "#{state_abbreviation} " if state_abbreviation
    address_str << "#{zipcode}" if zipcode

    self['premise_full'] = premise_str.strip
    self['street_number_full'] = street_number_str.strip
    self['street_name_full'] = street_name_str.strip
    
    self['address_full'] = address_str.strip
  end

  def generate_uri
    self['uri'] = address_full.downcase.gsub(/[^a-z0-9]/,'_').squeeze('_').gsub(/^\-|\-$/,'') if new?
    puts self.uri
  end

  def check_address_uniqueness
    if self.new_document? && State.get(self.uri).nil?
      return true
    end
    return [false, "Address already exists in the database"]
  end
  
    
end

