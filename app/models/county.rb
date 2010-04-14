class County < CouchRestRails::Document
  
  include CouchRest::Validation
  
  ## CouchDB database and record key
  use_database :community
  unique_id :identifier
  
  ## Properties
  property :identifier
  property :name
  property :state_fips_code
  property :county_fips_code
  property :coordinate, :cast_as => 'Coordinate'

  timestamps!
  
  ## Validations
  validates_presence_of :name, :state_fips_code, :county_fips_code
#  validates_with_method :state_fips_code, :method => :check_fips_uniqueness
  
  before_save :generate_identifier
  
  ## CouchDB Views
  # query with:
  #   County.by_name - all counties sorted by name
  #   County.by_state_fips_code(:key => '02') - all counties that match FIPS code for Alaska
  #   County.get("county_02_270") - specific county by ID
  
  view_by :name
  view_by :state_fips_code
  
  # def check_fips_uniqueness
  #   if self.new_document? && County.fips_code(:key => self.fips_code).length > 0
  #     return [false, "A county has already been created with this FIPS code"]
  #   end
  #   return true
  # end
  
private
  def generate_identifier
    fips_str = "#{state_fips_code}_#{county_fips_code}"

    #Pattern for Unique ID: class_key
    self['identifier'] = self.class.to_s.downcase + '_' + fips_str if new?
  end

end
