class LocationsController < ApplicationController

# Weather Query: http://free.worldweatheronline.com/feed/weather.ashx?key=55d99285d6001415122608&q=46077&format=json

  # GET /locations
  # GET /locations.xml
  def index
    #@locations = [Location.find(3), Location.find(4)]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end

  def search
    search_term = params.fetch(:search, {})[:term]
    search_terms = search_term.gsub(" ", ",").split(",").select(&:present?)
    @location = Location.find_by_zip(params[:search][:term]) if params[:search].present?
    if @location.blank?
      flash[:error] = "Zip code not found."
      redirect_to locations_path
    else
      @location.request_count += 1
      @location.save
      redirect_to "/locations/#{@location.zip}"
    end
  end

  def search_by_zip
    zip_code = params[:zip]
    @location = Location.find_by_zip(zip_code)
    render :action => "show"
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find_by_zip(params[:zip])
    #@location = Location.find(params[:id])
    # @location.request_count += 1
    # @location.save

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to(@location, :notice => 'Location was successfully created.') }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
end
