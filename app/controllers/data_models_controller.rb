class DataModelsController < ApplicationController

  # GET /data_models
  def index
    @data_models = DataModel.by_title
  end

  # GET /data_models/:id
  def show
    # Using CouchDB -- use Get method rather then Find used by ActiveRecord
    @data_model = DataModel.get(params[:id])

    if @data_model.nil?
      flash[:error] = 'Data Model not found.'
      redirect_to(data_models_url)
    end
  end

  # GET /data_models/new
  def new
    @data_model = DataModel.new
  end

  # GET /data_models/:id/edit
  def edit
    @data_model = DataModel.get(params[:id])

    if @data_model.nil?
      flash[:error] = 'Data Model not found.'
      redirect_to(data_models_url)
    end
  end

  # POST /data_models
  def create
    @data_model = DataModel.new(params[:data_model])
    @data_model.metadata = (params[:dces_metadata])

    # logger.debug  "****"
    # logger.debug "New data_model values: #{@data_model.inspect}"
    # logger.debug "dces_metadata values: #{params[:dces_metadata].inspect}"
    # logger.debug  "****"

    if @data_model.save
      flash[:notice] = 'Data Model successfully created.'
      redirect_to(@data_model)
    else
      flash[:error] = 'Unable to create Data Model.'
      render :action => "new"
    end
  end

  # PUT /data_models/:id
  def update
    @data_model = DataModel.get(params[:id])

    # logger.debug  "****"
    # logger.debug "Database data_model values: #{@data_model.inspect}"
    # logger.debug "Form data_model values: #{params[:data_model].inspect}"
    # logger.debug "Form dces_metadata values: #{params[:dces_metadata].inspect}"
    # logger.debug  "****"
    
    unless @data_model.nil?
      if @data_model['_rev'].eql?(params[:data_model]["rev"])
        
        @data_model.update_attributes_without_saving(
          :title => params[:data_model]["title"],
          :metadata => params[:dces_metadata]
        )
        
        if @data_model.save
          flash[:notice] = 'Data Model successfully updated.'
          redirect_to(@data_model) 
        else
          flash[:error] = "Update conflict. This data_model has been updated elsewhere, reload data_model, then update again."
          render :action => "edit" 
        end
      else
        flash[:error] = "Update conflict. This data_model has been updated elsewhere, reload data_model, then update again."
        render :action => "edit" 
      end
    else
      flash[:error] = "Data Model not found. The data_model could not be found, refresh the data_model list and try again."
      redirect_to(data_models_url)
    end
  end
  

  # DELETE /data_models/:id
  def destroy
    @data_model = DataModel.get(params[:id])
    unless @data_model.nil?
      @data_model.destroy
      redirect_to(data_models_url)
    else
      flash[:error] = "Data Model not found. The data_model could not be found, refresh the data_model list and try again."
      redirect_to(data_models_url)
    end
  end
end
