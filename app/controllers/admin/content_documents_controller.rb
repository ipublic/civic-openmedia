class Admin::ContentDocumentsController < ApplicationController
  
  def index
    @content_documents = ContentDocument.all
  end
  
  # GET /content_document/new
  def new
    @content_document = ContentDocument.new
    @metadata = Metadata.new
#    @properties = Property.new
  end

  def create
    @content_document = ContentDocument.new(params[:content_document])
    @content_document.metadata = (params[:metadata])
    
#    @content_document.properties = (params[:properties])

    # logger.debug  "****"
    # logger.debug "New content_document values: #{@content_document.inspect}"
    # logger.debug "metadata values: #{params[:metadata].inspect}"
    # logger.debug "properties values: #{params[:properties].inspect}"
    # logger.debug  "****"

    if @content_document.save
      flash[:notice] = 'Content Document successfully created.'
      redirect_to([:admin, @content_document])
    else
      flash[:error] = 'Unable to create Content Document.'
      render :action => "new"
    end
  end

  def show
    # Using CouchDB -- use Get method rather then Find used by ActiveRecord
    @content_document = ContentDocument.get(params[:id])

    if @content_document.nil?
      flash[:error] = 'ContentDocument not found.'
      redirect_to(content_documents_url)
    end
  end

  def edit
    @content_document = ContentDocument.get(params[:id])

    unless @content_document.nil?
      @metadata = @content_document.metadata
    else
      flash[:error] = 'Content Document not found.'
      redirect_to(content_documents_url)
    end
  end
  
  def update
    @content_document = ContentDocument.get(params[:id])

    # logger.debug  "****"
    # logger.debug "Database organization values: #{@organization.inspect}"
    # logger.debug "Form organization values: #{params[:organization].inspect}"
    # logger.debug "Form dces_metadata values: #{params[:dces_metadata].inspect}"
    # logger.debug  "****"

    unless @content_document.nil?
      if @content_document['_rev'].eql?(params[:content_document]["rev"])

        # Update without changing the class
        @content_document.update_attributes_without_saving(
          :title => params[:content_document]["title"],
          :uri => params[:content_document]["uri"]
        )

        @content_document.metadata = (params[:metadata])
#        @content_document.properties = (params[:properties])


        if @content_document.save
          flash[:notice] = 'Content Document successfully updated.'
          redirect_to([:admin, @content_document]) 
        else
          flash[:error] = "Update conflict. This Content Document has been updated elsewhere, reload ContentDocument, then update again."
          render :action => "edit" 
        end
      else
        flash[:error] = "Update conflict. This Content Document has been updated elsewhere, reload ContentDocument, then update again."
        render :action => "edit" 
      end
    else
      flash[:error] = "ContentDocument not found. The Content Document could not be found, refresh the ContentDocument list and try again."
      redirect_to(content_documents_url)
    end
  end
  
  def destroy
    @content_document = ContentDocument.get(params[:id])
    @content_document.destroy

    respond_to do |format|
      format.html { redirect_to(admin_content_documents_url) }
      format.xml  { head :ok }
    end
  end
end
