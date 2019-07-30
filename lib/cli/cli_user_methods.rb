# require_relative '/lib/models/user.rb'
require_relative '../../config/environment'

# User specific methods

require 'pry'

def user_login
    username = PROMPT.ask("Please enter your username:", required: true)
    # binding.pry
    if User.find_by user_name: username
        current_user = User.find_by user_name: username
        password = PROMPT.ask("Please enter your password:", required: true)
            if current_user.password == password
                return current_user
            else
                puts "Incorrect password, please try again!"
            end

    else 
        puts "Username not found please create a new Account!"
        create_new_user_account
    end

end

def decision_tree
    PROMPT.select("What would you like to do?") do |menu|
        menu.choice "Update your user account"
        menu.choice "Delete your user account"
        menu.choice "Search for concerts"
        menu.choice "Buy ticket"
        menu.choice "Sell ticket"
        menu.choice "Logout"
    end
end

def create_new_user_account
    user_fullname = PROMPT.ask("Please enter your full name:")
    
    user_age = PROMPT.ask("Please enter your age (in years):")
     
    user_username = PROMPT.ask("Please create a new username:")
     
    user_password = PROMPT.ask("Please create a password:")
     
    user_email = PROMPT.ask("Please enter you email address")

    User.create(user_name: user_username, name: user_fullname, age: user_age, email: user_email, password: user_password)
end

def update_user_account
    puts "What would you like to update?"
    # (Needs to find unique id)
    # User.update(Where?)
end

def delete_user_account
    puts "Are you sure you want to delete your account? Doing so will sell all tickets!"
    User.delete(id = user.id)
end

def search_for_concerts
end

def buy_ticket
end

def sell_ticket
end

def Logout
end
