# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def mixed_case(name)
     name.downcase.gsub(/\b\w/) {|first| first.upcase }
  end
  
  #transform true/false to yes/no strings
  def boolean_to_human(test)
    test  ? "Yes" : "No"
  end
end
