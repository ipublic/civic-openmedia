class Metadata < Hash
  
  include CouchRest::CastedModel
  include CouchRest::Validation

  # See http://dublincore.org/documents/usageguide/elements.shtml

  ## These propoerties are DCMI
  property :title
  property :description
  property :uri

  # Reference DCMI Type vocubulary: http://dublincore.org/documents/dcmi-type-vocabulary/
  property :type, :alias => :dcmi_type, :default => 'Dataset'

  property :keywords, :cast_as => ['String'] # cast as an array of strings

  property :creator_organization_id
  property :publisher_organization_id
  property :maintainer_organization_id

  property :language, :default => 'en-US'

  # reference to Open311, NIEM UCR other standards
  property :conforms_to

  # See http://geonames.usgs.gov/domestic/metadata.htm
  property :geographic_coverage  # Geographic bounds, jurisdiction name from controlled vocab, 
                              # e.g.; GNIS or Thesaurus of Geographic Names [TGN]
  property :update_frequency, :alias => :accrual_periodity # , :alias => :update_interval_in_minutes

  # earliest and oldest record in set
  property :beginning_date, :type => Date
  property :ending_date, :type => Date

  # creation or availability date of the resource
  property :created_date, :type => Date
  property :last_updated, :type => Date
  property :released, :type => Date  #, :alias => :date, :cast_as => 'Date', :init_method => 'parse'

  # string or URL describing usage, disclaimers 
  property :license, :alias => :rights

  ## Validations
#  validates_presence_of :title

end
