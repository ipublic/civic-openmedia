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
    @catalog.metadata = Metadata.new(params[:metadata])

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
    @updated_catalog = Catalog.new(params[:catalog])

    @revs = @catalog['_rev'] + ' ' + @updated_catalog['rev']

    if @catalog['_rev'].eql?(@updated_catalog.delete("rev"))
      @updated_catalog.delete("couchrest-type")
      
      @updated_catalog.metadata = Metadata.new(params[:metadata])

      respond_to do |format|
        if @catalog.update_attributes(@updated_catalog)
          flash[:notice] = 'Successfully updated Catalog.'
          format.html { redirect_to(admin_catalogs_path) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @catalog.errors, :status => :unprocessable_entity }
        end
      end
    else
      # Document revision is out of sync
      flash[:notice] = 'Update conflict. Catalog has been updated elsewhere, reload Catalog page, then update again. ' + @revs
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @catalog.errors, :status => :unprocessable_entity }
      end
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
