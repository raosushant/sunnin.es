#MongoDB configuration class
class MongoConfig
   # Class methods:
   class << self
      attr_accessor :connection
   end
end
 
# Initialize MongoDB connection
#connection = Mongo::Connection.new("localhost", 27017)
db = connection.db("DB_NAME")
auth = db.authenticate("USERNAME","PASSWORD")
 
# Save MongoDB connection in the MongoConfig class
MongoConfig.connection = connection