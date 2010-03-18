module DataModelsHelper

  def add_property_definition_link(name) 
    link_to_function name do |page| 
      page.insert_html :bottom, :property_definitions, :partial => 'property_definition', :object => PropertyDefinition.new 
    end 
  end
end
