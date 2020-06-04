# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :restaurants do
  primary_key :id
  String :name
  String :description, text: true
  String :location
  String :phone
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :restaurant_id
  foreign_key :user_id
  String :comments, text: true
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

# Insert initial (seed) data
restaurant_table = DB.from(:restaurants)

restaurant_table.insert(name: "Messa", 
                        description: "French fusion cuisine",
                        location: "HaArbaa St 19, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-685-6859")

restaurant_table.insert(name: "Shila", 
                        description: "XXX",
                        location: "182 Ben Yehuda Street, Tel Aviv",
                        phone: "+972 3-522-1224")

restaurant_table.insert(name: "Yaffo Tel Aviv", 
                        description: "XXX",
                        location: "Yigal Alon St 98, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-624-9249")

restaurant_table.insert(name: "Fu Sushi", 
                        description: "XXX",
                        location: "Dizengoff St 302, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-605-1000")
