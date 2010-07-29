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
    @dataset_update = Dataset.new(params[:dataset])
    @attachment = params[:attachment][:uploaded_file]
    
    # logger.debug  "****"
    # logger.debug  "IN UPLOAD_FILE"
    # logger.debug "Dataset_update values: #{@dataset_update.inspect}"
    # logger.debug "Dataset values: #{@dataset.inspect}"
    # logger.debug "Attachment values: #{@attachment.inspect}"
    # logger.debug  "****"

    @dataset.update_attributes_without_saving(
      :delimiter_character => @dataset_update["delimiter_character"],
      :column_header_row => @dataset_update["column_header_row"]
    )
    
    @dataset['_attachments'] ||= {}
    @dataset['_attachments'][@attachment.original_filename] = {
      'type' => @attachment.content_type.chomp,
      'data' => @attachment.read
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
    require 'ruport'
    @dataset = Dataset.get(params[:id])
    
    # Determine if attachment was added on latest revision
    @attachments = @dataset['_attachments']
    @attachments.each { |k, v| @attachment_name = k if (v['revpos'] == @dataset['_rev'].to_i) }
    
    # @xtab = OpenMedia::ExtendedTable.parse(
    #     @dataset.fetch_attachment(@attachment_name),
    #     :has_names => @dataset.column_header_row,
    #     :csv_options => { :col_sep => @dataset.delimiter_character }
    #   ) unless @attachment_name.nil?

      @xtab = Ruport::Data::Table.parse(
          @dataset.fetch_attachment(@attachment_name),
          :has_names => @dataset.column_header_row,
          :csv_options => { :col_sep => @dataset.delimiter_character }
        ) unless @attachment_name.nil?
  end
  
  def load_attachment
    @dataset = Dataset.get(params[:id])
    
    @attachments = @dataset['_attachments']
    @attachments.each { |k, v| @attachment_name = k if (v['revpos'] == @dataset['_rev'].to_i) }
    
    

  end
  
  # def preview
  #   @dataset = Dataset.get(params[:id])
  #   @attachments = @dataset['_attachments']
  #    @attachments.each { |k, v| @attachment_name = k if (v['revpos'] == @dataset['_rev'].to_i) }
  # 
  #    @xtab = OpenMedia::ExtendedTable.parse(
  #        @dataset.fetch_attachment(@attachment_name),
  #        :has_names => @dataset.column_header_row,
  #        :csv_options => { :col_sep => @dataset.delimiter_character }
  #      ) unless @attachment_name.nil?
  # end
  
  def refine
  end
  
  def describe
  end

end