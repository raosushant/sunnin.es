class Location
  include Mongoid::Document

  field :zipcode,           type: String
  field :state_abbr,        type: String
  field :city,              type: String
  field :state,             type: String
  field :loc,               type: Array
  field :tz,                type: String
  attr_accessible :_id, :zipcode, :state_abbr, :city, :state, :loc, :tz
  
  index({ loc: '2d' }, { background: true })
  
end
