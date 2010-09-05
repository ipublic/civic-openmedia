module MetadataHelper
  
  def format_metadata_date(raw_date)
    rtn = !raw_date.nil? ? raw_date.to_time.to_s(:full_date_only) : "undefined"
  end
  
end
