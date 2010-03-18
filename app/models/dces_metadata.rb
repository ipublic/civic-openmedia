class DcesMetadata < Hash
  include CouchRest::CastedModel
  include CouchRest::Validation
  # See http://dublincore.org/documents/usageguide/elements.shtml

#  validates_presence_of :title
#  attr_accessor :title
  
  property :title, :alias => :name
  property :identifier, :alias => :uri
  property :subject, :alias => :tags, :cast_as => ['String'] # tags, cast as an array of strings
  property :creator
  property :contributor
  property :publisher
  property :description
  
  # Reference DCMI Type vocubulary: http://dublincore.org/documents/dcmi-type-vocabulary/
  property :type, :alias => :dcmi_type, :default => 'Dataset'

  # Reference Internet Media type (MIME Types): http://www.iana.org/assignments/media-types/
  property :format, :alias => :dces_format, :default => 'text/plain'
  property :language, :default => 'en-US'
  
  property :source
  property :relation
  property :spatial_coverage  # Geographic bounds, jurisdiction name from controlled vocab, e.g.; Thesaurus of Geographic Names [TGN]
  property :temporal_coverage # temporal period (a period label, date, or date range)

  # string or URL describing usage, disclaimners 
  property :rights  

  # creation or availability date of the resource
  property :date #, :cast_as => 'Date', :init_method => 'parse'

  property :accrual_periodity, :alias => :update_interval_in_minutes
#  property :data_accuracy
 
  def to_s
    metadata_str = "#{title}" if title
    metadata_str << "\n#{identifier}" if identifier
    metadata_str << "\n#{subject}" if subject
    metadata_str << "\n#{creator}" if creator
    metadata_str << "\n#{source}" if source
    metadata_str << "\n#{contributor}" if contributor
    metadata_str << "\n#{publisher}" if publisher
    metadata_str << "\n#{type}" if type
    metadata_str << "\n#{format}" if format
    metadata_str << "\n#{language}" if language
    metadata_str << "\n#{relation}" if relation
    metadata_str << "\n#{spatial_coverage}, " if spatial_coverage
    metadata_str << "\n#{temporal_coverage}" if temporal_coverage
    metadata_str << "\n#{rights}" if rights
    metadata_str << "\n#{date}" if date
    metadata_str << "\n#{description}" if description
    metadata_str << "\n#{accrual_periodity}" if accrual_periodity
    metadata_str
  end
end

