module Admin::DatasetsHelper
  def wrap_td_tags(data_value)
    data_value
  end
  
  def sorted_attribute_list(ruport_record)
  	list = ruport_record.attributes.sort
  end
end