module MongoExtn
  class MongoExtn
    @conn

    def initialize 
      @conn = MongoConfig.connection 
    end

    @@instance = MongoExtn.new

    def self.instance
      return @@instance
    end    

    def find_nearby center, i
      r = @conn.db('sunny').command( 
        {:geoNear=>"locations", 
          :near=>center['loc'], 
          :query=>{}, 
          :num=>i.to_i})
      
      locations = Array.new 
      
      r['results'].each do |res|
        loc = Location.new(res['obj']) 
        dis = res['dis']
        locations.push LocationExtn.new(loc, dis, center) 
      end     
      
      get_top segment locations
    end
    
    def get_top seg_locs
      seg_locs.collect { |s| s.last } 
      
      #top = Set.new
      #for i in 0..3
      #  for j in 0..3
      #    next if i==j 
      #    top.add(top_4[j]) if (top_4[j].brng.abs - top_4[i].brng.abs).abs > 10
      #  end 
      #end
      #top
    end
    
    def segment locations 
      n_east = Array.new 
      s_east = Array.new 
      s_west = Array.new 
      n_west = Array.new 
       
      locations.each do |a| 
        n_east << a if a.brng.between?(-180, -90) 
        s_east << a if a.brng.between?(-90 , -0.11111) 
        s_west << a if a.brng.between?(0   , 90) 
        n_west << a if a.brng.between?(90  , 180) 
      end
      
      Array.new [n_east, s_east, s_west, n_west]
    end 
    
    def sort_arr_by_dis arr
      arr.sort_by! {|a| a.dis }
    end
    
    def sort_hash_by_dis arr
      arr.sort_by! {|a| a[:dis].to_f }
    end 
    
    private_class_method :new    
  end
  
  class LocationExtn
    attr_accessor :location, :dis, :loc_to, :brng
    
    def initialize location, dis, loc_to
      @location     = location 
      @dis          = dis
      @loc_to       = loc_to      
      bearing loc_to
    end

    def to loc_to 
      lat1 = toRad @location.loc[1]
      lon1 = toRad @location.loc[0]
      lat2 = toRad loc_to.loc[1]
      lon2 = toRad loc_to.loc[0]

      @dis = Math.acos(Math.sin(lat1)*Math.sin(lat2) + 
                        Math.cos(lat1)*Math.cos(lat2) *
                        Math.cos(lon2-lon1)) * 6371;
    end
    
    def bearing loc_to
      dLat = toRad (loc_to.loc[1]-@location.loc[1])
      dLon = toRad (loc_to.loc[0]-@location.loc[0])
      lat1 = toRad @location.loc[1]
      lat2 = toRad loc_to.loc[1]
            
      y = Math.sin(dLon) * Math.cos(lat2)
      x = Math.cos(lat1)*Math.sin(lat2) -
              Math.sin(lat1)*Math.cos(lat2)*Math.cos(dLon)
      @brng = toDeg Math.atan2(y, x)    
    end 

    def toRad deg
      deg * Math::PI / 180
    end    
    
    def toDeg rad
      rad * 180 / Math::PI
    end 
  end
end