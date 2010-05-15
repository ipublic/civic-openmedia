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
