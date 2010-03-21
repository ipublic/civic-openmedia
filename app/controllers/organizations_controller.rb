class OrganizationsController < ApplicationController

    # GET /organizations
    def index
      @organizations = Organization.by_name
    end

    # GET /organizations/:id
    def show
      # Using CouchDB -- use Get method rather then Find used by ActiveRecord
      @organization = Organization.get(params[:id])

      if @organization.nil?
        flash[:error] = 'Organization not found.'
        redirect_to(organizations_url)
      end
    end

    # GET /organizations/new
    def new
      @organization = Organization.new
    end

    # GET /organizations/:id/edit
    def edit
      @organization = Organization.get(params[:id])
      if @organization.nil?
        flash[:error] = 'Organization not found.'
        redirect_to(organizations_url)
      end
    end

    # POST /organizations
    def create
      @organization = Organization.new(params[:organization])
      @organization.point_of_contact = (params[:contact])
      @organization.address = (params[:address])

      # logger.debug  "****"
      # logger.debug "New organization values: #{@organization.inspect}"
      # logger.debug "dces_metadata values: #{params[:dces_metadata].inspect}"
      # logger.debug  "****"

      if @organization.save
        flash[:notice] = 'Organization successfully created.'
        redirect_to(@organization)
      else
        flash[:error] = 'Unable to create Organization.'
        render :action => "new"
      end
    end

    # PUT /organizations/:id
    def update
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
            :description => params[:organization]["description"],
            :point_of_contact => params[:contact],
            :address => params[:address]
          )

          if @organization.save
            flash[:notice] = 'Organization successfully updated.'
            redirect_to(@organization) 
          else
            flash[:error] = "Update conflict. This organization has been updated elsewhere, reload organization, then update again."
            render :action => "edit" 
          end
        else
          flash[:error] = "Update conflict. This organization has been updated elsewhere, reload organization, then update again."
          render :action => "edit" 
        end
      else
        flash[:error] = "Organization not found. The organization could not be found, refresh the organization list and try again."
        redirect_to(organizations_url)
      end
    end


    # DELETE /organizations/:id
    def destroy
      @organization = Organization.get(params[:id])
      unless @organization.nil?
        @organization.destroy
        redirect_to(organizations_url)
      else
        flash[:error] = "Organization not found. The organization could not be found, refresh the organization list and try again."
        redirect_to(organizations_url)
      end
    end
  end
