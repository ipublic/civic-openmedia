class Admin::SettingController < ApplicationController
  def index
    @settings = Setting.all
  end
  
  def new
    @setting = Setting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @setting }
    end
  end
  
  def create
    @setting = Setting.new(params[:setting])

    if @setting.save
      flash[:notice] = 'Settings successfully created.'
      redirect_to([:admin, @setting])
    else
#      flash[:error] = 'Unable to create Catalog.'
      render :action => "new"
    end
  end

  def show
    @setting = Setting.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @setting }
    end
  end

  def edit
    @setting = Setting.get(params[:id])
  end

  def update
    @setting = setting.find(params[:id])
    @setting.system_id = params[:system_id]

    respond_to do |format|
      if @setting.update_attributes(params[:segment])
        flash[:notice] = 'Successfully updated site settings.'
        format.html { redirect_to(@setting) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @setting.errors, :status => :unprocessable_entity }
      end
    end
  end

end
