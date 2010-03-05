class State < CouchRestRails::Document
  
  include CouchRest::Validation
  
  ## CouchDB database and record key
  use_database :catalog
  unique_id :abbreviation #natural key
  
  ## Properties
  property :name, :length => 1...20
  property :abbreviation, :length => 1...2
  property :state_fips_code #, :read_only => true
  property :coordinate, :cast_as => 'Coordinate'
    
  timestamps!

  ## Validations
  validates_presence_of :name
  validates_numericality_of :state_fips_code
  validates_with_method :abbreviation, :method => :check_abbreviation_uniqueness

  before_save :set_text_case
  
  ## CouchDB Views
  # query with State.by_name or State.by_fips_code
  view_by :name
  view_by :abbreviation
  view_by :state_fips_code

  ## This constant assignment will throw error when DB is first initialized 
  ## (until model views are loaded to CouchDB)
  NAMES_IDS = self.all.map do |m|
    [m.name, m.abbreviation]
  end  
  
  def check_abbreviation_uniqueness
    if self.new_document? && State.get(self.abbreviation.upcase).nil?
      return true
    end
    return [false, "A state has already been created with this abbreviation"]
  end

private
  def set_text_case
    self.abbreviation = abbreviation.upcase
    self.name = mixed_case(name)
  end

  def mixed_case(name)
     name.downcase.gsub(/\b\w/) {|first| first.upcase }
  end
  
#  =begin
#    TODO mod create_or_update to update existing and trap insert failures
#  =end
  def self.create_or_update(options = {})
    abbreviation = options.delete('abbreviation')
    record = State.get(options['abbreviation']) || State.new
    record.attributes = options
    record.save!
    
    record
  end
  
end
