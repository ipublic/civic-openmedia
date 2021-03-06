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
    @phone = Phone.new
    @contact = Contact.new
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])
    @organization.phones = (params[:phone])
    @organization.addresses = (params[:address])
    
    @organization.contacts = (params[:contact])


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
      @contact = @organization.contacts[0]
      @address ||= []
#      @address = @organization.addresses[0]
    else
      flash[:error] = 'Organization not found.'
      redirect_to(admin_organizations_url)
    end
  end

  # PUT /organizations/:id
  def update
    @organization = Organization.get(params[:id])
    @updated_organization = Organization.new(params[:organization])
    
    @revs = @organization['_rev'] + ' ' + @updated_organization['rev']

    if @organization['_rev'].eql?(@updated_organization.delete("rev"))
      @updated_organization.delete("couchrest-type")
      @updated_organization.contacts = Contact.new(params[:contact])
      @updated_organization.addresses = Address.new(params[:address])

      respond_to do |format|
        if @organization.update_attributes(@updated_organization)
          flash[:notice] = 'Successfully updated Organization.'
          format.html { redirect_to(admin_organizations_path) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
        end
      end
    else
      # Document revision is out of sync
      flash[:notice] = 'Update conflict. This Organization has been updated elsewhere, reload Organziztion page, then update again. ' + @revs
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
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
