class Admin::DatasetsController < ApplicationController
  
  def index
    @datasets = Dataset.all
  end
  
  def show
    @dataset = Dataset.get(params[:id])
  end
  
  def new
    @dataset = Dataset.new
  end
   
  def upload_file
#    @dataset = Dataset.new(params[:admin][:dataset])
    @dataset = Dataset.new(params[:dataset])

    if @dataset.save
      flash[:notice] = 'File successfully uploaded.'
#      render :action => "import"
      redirect_to preview_admin_dataset_url(@dataset)
    else
      flash[:error] = 'Error uploading datafile.'
      render :action => "new"
    end
  end
  
  def import
    @dataset = Dataset.new(params[:dataset])
    @connection = Connection.new(params[:connection])
  end
  
  def preview
    @dataset = Dataset.get(params[:id])
    @xtab = OpenMedia::ExtendedTable.parse @dataset.uploaded_content.to_s
  end
  
  def refine
  end
  
  def describe
  end

end