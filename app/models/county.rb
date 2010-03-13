class County < CouchRestRails::Document
  
  include CouchRest::Validation
  
  ## CouchDB database and record key
  use_database :catalog
  unique_id :fips_code # coumpound natural key
  
  ## Properties
  property :name
  property :state_fips_code
  property :county_fips_code
  property :coordinate, :cast_as => 'Coordinate'

  timestamps!
  
  set_callback :save, :before, :generate_fips_code

  ## Validations
  validates_presence_of :name
  validates_presence_of :state_fips_code
  validates_presence_of :county_fips_code
  validates_numericality_of :county_fips_code
  validates_numericality_of :state_fips_code
  validates_with_method :state_fips_code, :method => :check_fips_uniqueness
  
  ## CouchDB Views
  # query with County.by_name
  view_by :name


  def generate_fips_code
    fips_str = self.class.to_s + '-'
    fips_str << "#{state_fips_code}, " if state_fips_code
    fips_str << "#{county_fips_code}, " if county_fips_code

    self['fips_code'] = fips_str
  end
  
  def check_fips_uniqueness
    if self.new_document? && County.fips_code(:key => self.fips_code).length > 0
      return [false, "A county has already been created with this FIPS code"]
    end
    return true
  end
  

end
