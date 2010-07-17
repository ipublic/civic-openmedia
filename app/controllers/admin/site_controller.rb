class Admin::SiteController < ApplicationController
  
  def new
    @site = Site.new
    @gnis = Gnis.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site }
    end
  end
  
  def create
    @site = Site.new(params[:site])
    @gnis = Gnis.new(params[:gnis])
    
    @site.gnis = @gnis

    if @site.save
      flash[:notice] = 'Site successfully created.'
      redirect_to([:admin, @site])
#      redirect_to(admin_site_path(@site))
    else
      flash[:error] = 'Unable to create Site.'
      render :action => "new"
    end
  end

  def show
    @site = Site.first
    @gnis = @site.gnis
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site }
    end
  end

  def edit
    @site = Site.first
    @gnis = @site.gnis
  end

  def update
    @site = Site.first
    @gnis = Gnis.new(params[:gnis])

    @site.gnis = @gnis

    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Successfully updated site settings.'
        format.html { redirect_to(@site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

end
