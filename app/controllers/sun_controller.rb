class SunController < ApplicationController
  include Weather
  include MongoExtn
  
  def index 
    #script
  end  
  
  def create
    redirect_to sun_path(:id => params[:sun][:zipcode])  
  end 
  
  def show    
    #find the log lat where you live 
    @source = Location.where(:zipcode => params[:id]).first
    if @source == nil      
      redirect_to :sun_index 
    else 
      keep_going
      if !@w.isSunny
        render :notfound
      end
    end  
    
  end
  
  def keep_going 
    i = 50
    stop = false 
    @cities_evaluated = Array.new 
    until (i >= 1000 || stop)
      #get top 4 locations 
      locs = MongoExtn.instance.find_nearby(@source, i)
      j = 0
      until (locs.size == j || stop)  
        next if locs[j].location == nil
        @w    = Weather.new locs[j].location
        @cities_evaluated.push @w
        stop = true if @w.isSunny 
        j += 1 
      end
      i += 250 
    end    
  end 
  
  def serialize_latlong 
    ActiveSupport::JSON.encode ({ :start => @source['loc'], :end => @w.location['loc']  })
  end 
  
  helper_method :serialize_latlong
  
end
