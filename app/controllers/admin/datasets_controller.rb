class Admin::DatasetsController < ApplicationController
  
  def index
    @datasets = Dataset.all
  end
  
  def show
    @dataset = Dataset.get(params[:id])
  end
  
  def new
    @dataset = Dataset.new
    @metadata = Metadata.new
  end
  
  def create
    @dataset = Dataset.new(params[:dataset])
    @dataset.metadata = Metadata.new(params[:metadata])

    if @dataset.save
      flash[:notice] = 'Dataset successfully created.'
      redirect_to upload_admin_dataset_url(@dataset)
    else
      flash[:error] = 'Unable to create Dataset.'
      render :action => "new"
    end
  end
  
  def upload
    @dataset = Dataset.get(params[:id])
    @attachment = Attachment.new({})
  end
   
  def upload_file
    @dataset = Dataset.get(params[:id])
    @attachment = params[:attachment][:uploaded_file]
    
    @content = @attachment.read
    @dataset['_attachments'] ||= {}
    @dataset['_attachments'][@attachment.original_filename] = {
      'type' => @attachment.content_type.chomp,
      'data' => @content
    }
   
    if @dataset.save
      flash[:notice] = 'File successfully uploaded.'
      redirect_to import_admin_dataset_url(@dataset)
    else
      flash[:error] = 'Error uploading datafile.'
      render :action => "new"
    end
  end
  
  def import
    @dataset = Dataset.get(params[:id])
    @xtab = OpenMedia::ExtendedTable.parse @dataset.uploaded_content.to_s
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