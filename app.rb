# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

restaurant_table = DB.from(:restaurants)
reviews_table = DB.from(:reviews)
users_table = DB.from(:users)


before do
    # SELECT * FROM users WHERE id = session[:user_id]
    @current_user = users_table.where(:id => session[:user_id]).to_a[0]
    puts @current_user.inspect
end


# Home page (all events)
get "/" do
    # before stuff runs
    @restaurants = restaurant_table.all
    view "restaurants"
end

# Show a single restaurant
get "/restaurants/:id" do
    @users_table = users_table
    # SELECT * FROM events WHERE id=:id
    @restaurant = restaurant_table.where(:id => params["id"]).to_a[0]
    # SELECT * FROM rsvps WHERE event_id=:id
    @reviews= reviews_table.where(:restaurant_id => params["id"]).to_a
    
    @current_user = users_table.where(:id => session[:user_id]).to_a[0]
    puts @current_user.inspect

    results = Geocoder.search(@restaurant[:location])
    @lat_long = results.first.coordinates.join(",")

    view "restaurant"
end


# Send SMS
post "/restaurants/:id/reviews/SMS" do
    # @SMS = restaurant_table.where(:id => params["id"]).to_a[0]
    account_sid = ENV["account_sid"]
    auth_token = ENV["auth_token"]
    number = params["number"]
    time = params["time"]
    client = Twilio::REST::Client.new(account_sid, auth_token)
    client.messages.create(
    from: "+19495654787", 
    to: "+18472198243",
    body: "#{number} people at #{time}"
    )
    view "SMS"
end



# Form to create a new Review
get "/restaurants/:id/reviews/new" do
    @restaurant = restaurant_table.where(:id => params["id"]).to_a[0]
    view "new_review"
end

# Receiving end of new Review form
post "/restaurants/:id/reviews/create" do
    reviews_table.insert(:restaurant_id => params["id"],
                       :user_id => @current_user[:id],
                       :comments => params["comments"],
                       :dish => params["dish"],
                       :stars => params["stars"])
    @restaurant = reviews_table.where(:id => params["id"]).to_a[0]
    view "create_review"
end

# Form to create a new user
get "/users/new" do
    view "new_user"
end

# Receiving end of new user form
post "/users/create" do
    users_table.insert(:name => params["name"],
                       :email => params["email"],
                       :password => BCrypt::Password.create(params["password"]))
    view "create_user"
end

# Form to login
get "/logins/new" do
    view "new_login"
end

# Receiving end of login form
post "/logins/create" do
    puts params
    email_entered = params["email"]
    password_entered = params["password"]
    # SELECT * FROM users WHERE email = email_entered
    user = users_table.where(:email => email_entered).to_a[0]
    if user
        puts user.inspect
        # test the password against the one in the users table
        if  BCrypt::Password.new(user[:password]) == password_entered
            session[:user_id] = user[:id]
            view "create_login"
        else
            view "create_login_failed"
        end
    else 
        view "create_login_failed"
    end
end

# Logout
get "/logout" do
    session[:user_id] = nil
    view "logout"
end