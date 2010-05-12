class Admin::SearchAllController < ApplicationController

  ITEM_PARTIALS = {
    Dataset => 'dataset',
    Organization => 'organization'
  }

  helper_method :item_partials

  def index
    @search = Search.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @search_alls }
    end
  end

  # GET /search_alls/1
  # GET /search_alls/1.xml
  def show
    @search = Search.find(params[:search][:what])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @search_all }
    end
  end

  # GET /search_alls/new
  # GET /search_alls/new.xml
  def new
    @search = Search.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @search }
    end
  end

  def item_partials
    ITEM_PARTIALS
  end
  
end
