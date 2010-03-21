module DataModelsHelper
  
  def organization_lookup(key)
    #Use the NAMES_IDS constant on Organization model to find Organization model given a key
    org_pair = Organization::NAMES_IDS.rassoc(key)
    org_name = org_pair.nil? ? "Unknown organization" : org_pair[0]
  end
  
  def add_property_definition_link(name) 
    link_to_function name do |page| 
      page.insert_html :bottom, :property_definitions, :partial => 'property_definition', :object => PropertyDefinition.new 
    end 
  end
end
