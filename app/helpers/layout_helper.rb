# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
# helper :layout

module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  # def form_date_to_json(year, month, day)
  #   Time.local(year.to_i, month.to_i, day.to_i)
  # end
  
  def database_collection
    Site::DATABASES.collect {|db_name| [db_name, db_name.downcase] }
  end

  def catalog_collection
#    Catalog::CATALOGS.collect {|cat_name| [cat_name, cat_name.downcase] }
    Catalog.by_title_and_identifier.collect {|o| [ o.title, o['_id']] }
  end

  def organization_collection
    Organization.by_name_and_identifier.collect {|o| [ o.name, o['_id']] }
  end

  def contact_collection
    Contact.by_name_and_email.collect {|o| [ o.name, o.email ] }
  end

  def state_collection
    State.by_name_and_abbreviation.collect {|o| [ o.name, o.abbreviation ] }
  end

  def get_organization_name(organization_id)
    unless organization_id.blank?
      Organization.get(organization_id).nil? ? "undefined" : Organization.get(organization_id).name
    else
      "undefined"
    end
  end
end