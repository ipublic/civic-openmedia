class Admin::CatalogsController < ApplicationController

  # GET /organizations
  def index
    @catalogs = Catalog.all
  end

  # GET /organizations/new
  def new
    @catalog = Catalog.new
    @metadata = Metadata.new
  end

  def create
    @catalog = Catalog.new(params[:catalog])
    @catalog.metadata = (params[:metadata])

    # logger.debug  "****"
    # logger.debug "New catalog values: #{@catalog.inspect}"
    # logger.debug "metadata values: #{params[:metadata].inspect}"
    # logger.debug  "****"

    if @catalog.save
      flash[:notice] = 'Catalog successfully created.'
      redirect_to([:admin, @catalog])
    else
#      flash[:error] = 'Unable to create Catalog.'
      render :action => "new"
    end
  end
  
  def show
    # Using CouchDB -- use Get method rather then Find used by ActiveRecord
    @catalog = Catalog.get(params[:id])

    if @catalog.nil?
      flash[:error] = 'Catalog not found.'
      redirect_to(admin_catalogs_url)
    end
  end

  def edit
    @catalog = Catalog.get(params[:id])

    unless @catalog.nil?
      @metadata = @catalog.metadata
    else
      flash[:error] = 'Catalog not found.'
      redirect_to(admin_catalogs_url)
    end
  end

  def update
    @catalog = Catalog.get(params[:id])

    # logger.debug  "****"
    # logger.debug "Database organization values: #{@organization.inspect}"
    # logger.debug "Form organization values: #{params[:organization].inspect}"
    # logger.debug "Form dces_metadata values: #{params[:dces_metadata].inspect}"
    # logger.debug  "****"

    unless @catalog.nil?
      if @catalog['_rev'].eql?(params[:catalog]["rev"])

        @catalog.update_attributes_without_saving(
          :name => params[:organization]["name"],
          :abbreviation => params[:organization]["abbreviation"],
          :website_url => params[:organization]["website_url"],
          :description => params[:organization]["description"],
          :point_of_contact => params[:contact],
          :address => params[:address]
        )

        if @catalog.save
          flash[:notice] = 'Catalog successfully updated.'
          redirect_to([:admin, @catalog]) 
        else
          flash[:error] = "Update conflict. This catalog has been updated elsewhere, reload catalog, then update again."
          render :action => "edit" 
        end
      else
        flash[:error] = "Update conflict. This catalog has been updated elsewhere, reload catalog, then update again."
        render :action => "edit" 
      end
    else
      flash[:error] = "Catalog not found. The catalog could not be found, refresh the catalog list and try again."
      redirect_to(admin_catalogs_url)
    end
  end

  # DELETE /catalogs/:id
  def destroy
    @catalog = Catalog.get(params[:id])
    
    unless @catalog.nil?

      # Delete all the dependent records
      @catalog_records = CatalogRecord.by_catalog_id(:key => @catalog['_id'] )
      @catalog_records.each do |cr|
        cr.destroy
      end
      
      @catalog.destroy

      redirect_to(admin_catalogs_url)
    else
      flash[:error] = "Catalog not found. The catalog could not be found, refresh the catalog list and try again."
      redirect_to(admin_catalogs_url)
    end
  end
end
