class Admin::DatasetsController < ApplicationController
  
  def index
    @datasets = Dataset.all
  end
  
  # GET /dataset/new
  def new
    @dataset = Dataset.new
    @metadata = Metadata.new
#    @properties = Property.new
  end

  def create
    @dataset = Dataset.new(params[:dataset])
    @dataset.metadata = (params[:metadata])
#    @dataset.properties = (params[:properties])

    logger.debug  "****"
    logger.debug "New dataset values: #{@dataset.inspect}"
    logger.debug "metadata values: #{params[:metadata].inspect}"
    logger.debug "properties values: #{params[:properties].inspect}"
    logger.debug  "****"

    if @dataset.save
      flash[:notice] = 'Dataset successfully created.'
      redirect_to([:admin, @dataset])
    else
      flash[:error] = 'Unable to create Dataset.'
      render :action => "new"
    end
  end

  def show
    # Using CouchDB -- use Get method rather then Find used by ActiveRecord
    @dataset = Dataset.get(params[:id])

    if @dataset.nil?
      flash[:error] = 'Dataset not found.'
      redirect_to(datasets_url)
    end
  end

  def edit
    @dataset = Dataset.get(params[:id])

    unless @dataset.nil?
      @metadata = @dataset.metadata
    else
      flash[:error] = 'Dataset not found.'
      redirect_to(datasets_url)
    end
  end
  
  def update
    @dataset = Dataset.get(params[:id])

    # logger.debug  "****"
    # logger.debug "Database organization values: #{@organization.inspect}"
    # logger.debug "Form organization values: #{params[:organization].inspect}"
    # logger.debug "Form dces_metadata values: #{params[:dces_metadata].inspect}"
    # logger.debug  "****"

    unless @dataset.nil?
      if @dataset['_rev'].eql?(params[:dataset]["rev"])

        # Update without changing the class
        @dataset.update_attributes_without_saving(
          :title => params[:dataset]["title"],
          :uri => params[:dataset]["uri"]
        )

        @dataset.metadata = (params[:metadata])
#        @dataset.properties = (params[:properties])


        if @dataset.save
          flash[:notice] = 'Dataset successfully updated.'
          redirect_to([:admin, @dataset]) 
        else
          flash[:error] = "Update conflict. This Dataset has been updated elsewhere, reload Dataset, then update again."
          render :action => "edit" 
        end
      else
        flash[:error] = "Update conflict. This Dataset has been updated elsewhere, reload Dataset, then update again."
        render :action => "edit" 
      end
    else
      flash[:error] = "Dataset not found. The Dataset could not be found, refresh the Dataset list and try again."
      redirect_to(datasets_url)
    end
  end
  
  def destroy
    @dataset = Dataset.get(params[:id])
    @dataset.destroy

    respond_to do |format|
      format.html { redirect_to(admin_datasets_url) }
      format.xml  { head :ok }
    end
  end
end
