def getTz
  tz = Hash.new
  tz['AL']	= 'Central Time (US & Canada)'
  tz['AK']	= 'Hawaii'
  tz['AZ']	= 'Mountain Time (US & Canada)'
  tz['AR']	= 'Central Time (US & Canada)'
  tz['CA']	= 'Pacific Time (US & Canada)'
  tz['CO']	= 'Mountain Time (US & Canada)'
  tz['CT']	= 'Eastern Time (US & Canada)'
  tz['DC']	= 'Eastern Time (US & Canada)'
  tz['DE']	= 'Eastern Time (US & Canada)'
  tz['FL']	= 'Eastern Time (US & Canada)'
  tz['GA']	= 'Eastern Time (US & Canada)'
  tz['HI']	= 'Alaska'
  tz['ID']	= 'Pacific Time (US & Canada)'
  tz['IL']	= 'Central Time (US & Canada)'
  tz['IN']	= 'Eastern Time (US & Canada)'
  tz['IA']	= 'Central Time (US & Canada)'
  tz['KS']	= 'Central Time (US & Canada)'
  tz['KY']	= 'Eastern Time (US & Canada)'
  tz['LA']	= 'Central Time (US & Canada)'
  tz['ME']	= 'Eastern Time (US & Canada)'
  tz['MD']	= 'Eastern Time (US & Canada)'
  tz['MA']	= 'Eastern Time (US & Canada)'
  tz['MI']	= 'Eastern Time (US & Canada)'
  tz['MN']	= 'Central Time (US & Canada)'
  tz['MS']	= 'Central Time (US & Canada)'
  tz['MO']	= 'Central Time (US & Canada)'
  tz['MT']	= 'Mountain Time (US & Canada)'
  tz['NE']	= 'Central Time (US & Canada)'
  tz['NV']	= 'Pacific Time (US & Canada)'
  tz['NH']	= 'Eastern Time (US & Canada)'
  tz['NJ']	= 'Eastern Time (US & Canada)'
  tz['NM']	= 'Mountain Time (US & Canada)'
  tz['NY']	= 'Eastern Time (US & Canada)'
  tz['NC']	= 'Eastern Time (US & Canada)'
  tz['ND']	= 'Central Time (US & Canada)'
  tz['OH']	= 'Eastern Time (US & Canada)'
  tz['OK']	= 'Central Time (US & Canada)'
  tz['OR']	= 'Pacific Time (US & Canada)'
  tz['PA']	= 'Eastern Time (US & Canada)'
  tz['RI']	= 'Eastern Time (US & Canada)'
  tz['SC']	= 'Eastern Time (US & Canada)'
  tz['SD']	= 'Central Time (US & Canada)'
  tz['TN']	= 'Central Time (US & Canada)'
  tz['TX']	= 'Central Time (US & Canada)'
  tz['UT']	= 'Mountain Time (US & Canada)'
  tz['VT']	= 'Eastern Time (US & Canada)'
  tz['VA']	= 'Eastern Time (US & Canada)'
  tz['WA']	= 'Pacific Time (US & Canada)'
  tz['WV']	= 'Eastern Time (US & Canada)'
  tz['WI']	= 'Central Time (US & Canada)'
  tz['WY']	= 'Mountain Time (US & Canada)'  
  tz
end 

def script
  conn = MongoConfig.connection
  l = Array.new 
  conn.db('sunny').collection('zipcodes').find().each do |x|
    tz = getTz
    n = Array.new  
    n.push x['longitude'].to_f
    n.push x['latitude'].to_f 
    zip = x['zip code'].to_s.size == 3 ? '00'+x['zip code'].to_s : x['zip code']
    m = Location.new(
      :zipcode => zip, 
      :loc => n , 
      :state_abbr => x['state abbreviation'], 
      :city     => x['city'], 
      :state    => x['state'],
      :tz       => tz[x['state abbreviation']])   
    m.save!
  end     
end