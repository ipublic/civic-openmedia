class Admin::OrganizationsController < ApplicationController

  # GET /organizations
  def index
    @organizations = Organization.by_name
  end

  # GET /organizations/:id
  def show
    # Using CouchDB -- use Get method rather then Find used by ActiveRecord
    @organization = Organization.get(params[:id])
    
    unless @organization.nil?
#        @datasets = Dataset.view_by_creator_organization_id(:key => @organization['_id'])
    else
      flash[:error] = "Organization not found for ID=#{params[:id]}"
      redirect_to(admin_organizations_url)
    end
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @address = Address.new
    @contact = Contact.new
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])
    @organization.points_of_contact = (params[:contact])
    @organization.addresses = (params[:address])

    # logger.debug  "****"
    # logger.debug "New organization values: #{@organization.inspect}"
    # logger.debug "dces_metadata values: #{params[:dces_metadata].inspect}"
    # logger.debug  "****"

    if @organization.save
      flash[:notice] = 'Organization successfully created.'
      redirect_to([:admin, @organization])
    else
      flash[:error] = 'Unable to create Organization.'
      render :action => "new"
    end
  end

  # GET /organizations/:id/edit
  def edit
    @organization = Organization.get(params[:id])
    unless @organization.nil?
      @contact = @organization.points_of_contact[0]
      @address = @organization.addresses[0]
    else
      flash[:error] = 'Organization not found.'
      redirect_to(admin_organizations_url)
    end
  end

  # PUT /organizations/:id
  def update
    # Grab the organization record from CouchDB -- we will compare with form version to verify no changes
    # have occured elsewhere that will result in conflict
    
    @organization = Organization.get(params[:id])

    # logger.debug  "****"
    # logger.debug "Database organization values: #{@organization.inspect}"
    # logger.debug "Form organization values: #{params[:organization].inspect}"
    # logger.debug "Form dces_metadata values: #{params[:dces_metadata].inspect}"
    # logger.debug  "****"

    unless @organization.nil?
      if @organization['_rev'].eql?(params[:organization]["rev"])

        @organization.update_attributes_without_saving(
          :name => params[:organization]["name"],
          :abbreviation => params[:organization]["abbreviation"],
          :website_url => params[:organization]["website_url"],
          :description => params[:organization]["description"]
          # ,
          # :addresses => params[:address],
          # :points_of_contact => params[:contact]
        )

        @organization.points_of_contact = (params[:contact])
        @organization.addresses = (params[:address])

        if @organization.save
          flash[:notice] = 'Organization successfully updated.'
          redirect_to([:admin, @organization]) 
        else
          flash[:error] = "Update conflict. This Organization has been updated elsewhere, reload Organization, then update again."
          render :action => "edit" 
        end
      else
        flash[:error] = "Update conflict. This Organization has been updated elsewhere, reload Organization, then update again."
        render :action => "edit" 
      end
    else
      flash[:error] = "Organization not found. The Organization could not be found, refresh the Organization list and try again."
      redirect_to(admin_organizations_url)
    end
  end


  # DELETE /organizations/:id
  def destroy
    @organization = Organization.get(params[:id])
    unless @organization.nil?
      @organization.destroy
      redirect_to(admin_organizations_url)
    else
      flash[:error] = "Organization not found. The organization could not be found, refresh the organization list and try again."
      redirect_to(admin_organizations_url)
    end
  end
end
