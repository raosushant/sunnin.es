require 'net/http'
module Weather
    
  class Weather
    attr_accessor :weatherCode
    attr_accessor :temp_f
    attr_accessor :temp_c
    attr_accessor :sys_observation_time
    attr_accessor :observation_time
    attr_accessor :weatherDesc
    attr_accessor :precipitation
    attr_accessor :humidity
    attr_accessor :wind
    attr_accessor :location
    attr_accessor :sys_obs_time
    
    def initialize location
      @location = location
      map_weather_icons
      getWeather
    end 
    
    def weather_icon      
      (@@weather_icon_map[weatherCode] || @@weather_icon_map['none'])
    end 
    
    def isSunny
      @weatherCode == "113" 
    end 
    
    private 
    
    def map_weather_icons 
      @@weather_icon_map = Hash.new
      @@weather_icon_map['113'] = 'tick_weather_032.png' #sunny 
      @@weather_icon_map['116'] = 'tick_weather_001.png' #partly cloudy 
      @@weather_icon_map['119'] = 'tick_weather_007.png' #cloudy       
      @@weather_icon_map['122'] = 'tick_weather_017.png' #overcast     
      
      @@weather_icon_map['143'] = 'tick_weather_011.png' #mist 
      @@weather_icon_map['176'] = 'tick_weather_011.png' #Patchy rain nearby  
      @@weather_icon_map['179'] = 'tick_weather_011.png' #Patchy snow nearby       
      @@weather_icon_map['182'] = 'tick_weather_011.png' #Patchy sleet nearby  
      
      @@weather_icon_map['185'] = 'tick_weather_015.png' #Patchy freezing 
      @@weather_icon_map['200'] = 'tick_weather_034.png' #Thundery outbreaks nearby  
      @@weather_icon_map['227'] = 'tick_weather_023.png' #Blowing snow       
      @@weather_icon_map['230'] = 'tick_weather_023.png' #Blizzard         
      
      @@weather_icon_map['248'] = 'tick_weather_015.png' #fog
      @@weather_icon_map['260'] = 'tick_weather_015.png' #freezing fog  
      @@weather_icon_map['263'] = 'tick_weather_018.png' #patchy light drizzle       
      @@weather_icon_map['266'] = 'tick_weather_018.png' #patchy light drizzle       
      
      @@weather_icon_map['281'] = 'tick_weather_018.png' #freezing drizzle  
      @@weather_icon_map['284'] = 'tick_weather_020.png' #heavy freezing drizzle   
      @@weather_icon_map['293'] = 'tick_weather_018.png' #patch light rain       
      @@weather_icon_map['296'] = 'tick_weather_018.png' #light rain     
      
      @@weather_icon_map['299'] = 'tick_weather_018.png' #moderate rain
      @@weather_icon_map['302'] = 'tick_weather_020.png' #moderate rain  
      @@weather_icon_map['305'] = 'tick_weather_020.png' #heavy rain       
      @@weather_icon_map['308'] = 'tick_weather_020.png' #heavy rain       

      @@weather_icon_map['311'] = 'tick_weather_015.png' #ligt freezing rain
      @@weather_icon_map['314'] = 'tick_weather_001.png' #frezzing moderate rain  
      @@weather_icon_map['317'] = 'tick_weather_007.png' #light sleet       
      @@weather_icon_map['320'] = 'tick_weather_009.png' #haevy sleet      

      @@weather_icon_map['323'] = 'tick_weather_024.png' #patchy snow
      @@weather_icon_map['326'] = 'tick_weather_024.png' #light snow  
      @@weather_icon_map['329'] = 'tick_weather_026.png' #mod snow       
      @@weather_icon_map['332'] = 'tick_weather_028.png' #mod snow
      
      @@weather_icon_map['355'] = 'tick_weather_031.png' #heavy snow
      @@weather_icon_map['338'] = 'tick_weather_031.png' #heavy snow 
      @@weather_icon_map['350'] = 'tick_weather_013.png' #ice pellets        
      @@weather_icon_map['353'] = 'tick_weather_018.png' #light rain     
      
      @@weather_icon_map['356'] = 'tick_weather_020.png' #moderate shower
      @@weather_icon_map['362'] = 'tick_weather_001.png' #sleet shower
      @@weather_icon_map['365'] = 'tick_weather_018.png' #heavy sleet shower       
      @@weather_icon_map['368'] = 'tick_weather_018.png' #light snow shower 
      
      @@weather_icon_map['371'] = 'tick_weather_031.png' #heavy snow shower
      @@weather_icon_map['374'] = 'tick_weather_013.png' #ice pellets
      @@weather_icon_map['377'] = 'tick_weather_013.png' #heavy ice pellets        

      @@weather_icon_map['386'] = 'tick_weather_034.png' # light thunder rain    
      @@weather_icon_map['389'] = 'tick_weather_036.png' # heavy thunder rain    
      @@weather_icon_map['392'] = 'tick_weather_034.png' # light thunder snow    
      @@weather_icon_map['395'] = 'tick_weather_036.png' # heavy thunder rain    
      
      @@weather_icon_map['none'] = 'tick_weather_010.png' # heavy thunder rain 
      
    end    
    
    def getWeather
       obj = WorldWeatherOnlineCallout.get_weather location.zipcode   
       return if obj['data']['error'] != nil
              
       @weatherCode     = obj['data']['current_condition'][0]['weatherCode']
       @temp_c          = obj['data']['current_condition'][0]['temp_C']
       @temp_f          = obj['data']['current_condition'][0]['temp_F']
       @obs_time        = obj['data']['current_condition'][0]['observation_time']
       @weatherDesc     = obj['data']['current_condition'][0]['weatherDesc'][0]['value']
       @wind            = obj['data']['current_condition'][0]['windspeedMiles']
       @humidity        = obj['data']['current_condition'][0]['humidity']
       @precipitation   = obj['data']['current_condition'][0]['precipMM']
       Time.zone = location['tz']
       @sys_obs_time    = Time.zone.now
    end       
  
  end
  
  class WorldWeatherOnlineCallout
        
    def self.create_callout loc 
      callout = Callout.new 
      callout.endpoint    = 'http://free.worldweatheronline.com/feed/weather.ashx?'
      callout.query       = 'q='+loc
      callout.format      = '&format=json'
      callout.num_of_days = '&num_of_days=1'
      callout.key         = '&key=INSERT_WEATHER_API_KEY_HERE'
      callout
    end 
    
    def self.get_weather loc
      create_callout(loc).get_response
    end 
  end 
  
  class Callout    
    attr_accessor :endpoint
    attr_accessor :query
    attr_accessor :format
    attr_accessor :num_of_days
    attr_accessor :key
     
    def get_response
      url = endpoint+query+format+num_of_days+key
      ActiveSupport::JSON.decode Net::HTTP.get_response(URI.parse url).body
      #ActiveSupport::JSON.decode "{ \"data\": { \"current_condition\": [ {\"cloudcover\": \"0\", \"humidity\": \"87\", \"observation_time\": \"07:17 AM\", \"precipMM\": \"0.0\", \"pressure\": \"1024\", \"temp_C\": \"7\", \"temp_F\": \"45\", \"visibility\": \"16\", \"weatherCode\": \"113\",  \"weatherDesc\": [ {\"value\": \"Clear\" } ],  \"weatherIconUrl\": [ {\"value\": \"http:\/\/www.worldweatheronline.com\/images\/wsymbols01_png_64\/wsymbol_0008_clear_sky_night.png\" } ], \"winddir16Point\": \"E\", \"winddirDegree\": \"90\", \"windspeedKmph\": \"6\", \"windspeedMiles\": \"4\" } ],  \"request\": [ {\"query\": \"95650\", \"type\": \"Zipcode\" } ],  \"weather\": [ {\"date\": \"2013-03-01\", \"precipMM\": \"0.0\", \"tempMaxC\": \"22\", \"tempMaxF\": \"72\", \"tempMinC\": \"11\", \"tempMinF\": \"53\", \"weatherCode\": \"113\",  \"weatherDesc\": [ {\"value\": \"Sunny\" } ],  \"weatherIconUrl\": [ {\"value\": \"http:\/\/www.worldweatheronline.com\/images\/wsymbols01_png_64\/wsymbol_0001_sunny.png\" } ], \"winddir16Point\": \"WNW\", \"winddirDegree\": \"283\", \"winddirection\": \"WNW\", \"windspeedKmph\": \"11\", \"windspeedMiles\": \"7\" } ] }}"
    end
  end 

end 
