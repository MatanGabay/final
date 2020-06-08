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
  String :dish
  String :stars
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
                        description: "French fusion cuisine, Chef Aviv Moshe's Messa celebrates haute cuisine with nostalgia from his mother's kitchen. From the kitchen of famed Chef Aviv Moshe, this impressive restaurant evokes a New York style with its impressive white-on-white dining room and black-on-black",
                        location: "HaArbaa St 19, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-685-6859")

restaurant_table.insert(name: "Shila", 
                        description: "An exciting open kitchen and unusual (yet very successful) flavour combinations are the two things diners at Shila- Sharon Cohen's Kitchen & Bar may well expect when headed here for an evening meal. Convenient location in the city's centre completes the package.",
                        location: "182 Ben Yehuda Street, Tel Aviv",
                        phone: "+972 3-522-1224")

restaurant_table.insert(name: "Yaffo Tel Aviv", 
                        description: "Contemporary Israeli cuisine with the menu composed of seafood served with rich tahini, handmade gnocchi, the freshest local vegetables, fresh-from-the-tabun focaccia and premium quality meats. This is Israeli cooking at its finest as all the best ingredients come together harmoniously on each plate.",
                        location: "Yigal Alon St 98, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-624-9249")

restaurant_table.insert(name: "Fu Sushi", 
                        description: "Modern restaurant offering specialty sushi & a variety of Asian-fusion dishes & cocktails.",
                        location: "Dizengoff St 302, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-605-1000")

restaurant_table.insert(name: "Toto", 
                        description: "Chef Yaron Shalev's Toto showcases a unique attention to detail and creativity abound. With it's flattering light, clean lines, comfortable seating and a seasonal menu prepared in style, It's no surprise that Toto is one of the most loved spots for fine dining in Tel Aviv",
                        location: "Berkovich St 4, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-693-5151")

restaurant_table.insert(name: "Taizu", 
                        description: "The restaurant belongs to the fine casual dining category with the highest level of food, design and hospitality in an informal and accessible setting. The choice of chefs, it was perfect !. High kitchen is here, in Tel Aviv. ... The food is great, the service friendly and right pace.",
                        location: "Tiomkin St 16, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-522-5005")

restaurant_table.insert(name: "Popina", 
                        description: "Orel Kamahi chef restaurant, serves a variety of meticulously prepared dishes that creatively combine seasonal raw materials from Israel and abroad and are served in its unique and elegant style. This restaurant is included in our 'Best Upscale Restaurants in Tel Aviv' guide",
                        location: "Ahad HaAm St 3, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-575-7477")

restaurant_table.insert(name: "Pronto", 
                        description: "One of the oldest Italian restaurants in Tel Aviv that serves creatively presented pasta, meat and fish dishes. The formal, yet friendly and unpretentious ambiance makes it a popular spot amongst a sophisticated crowd. Every Monday there is an additional menu with Vegan specials.",
                        location: "Herzl St 4, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-566-0915")

restaurant_table.insert(name: "Thai House", 
                        description: "Established in 1996 by the couple Yariv and Sonan (Lek) Melili. The restaurant introduces cuisine based on traditional food from the north-eastern Isan region, combining typical dishes and classical street food from southern Thailand to provide an authentic journey into local cuisine.",
                        location: "Bograshov St 8, Tel Aviv-Yafo, Israel",
                        phone: "+972 3-517-8568")