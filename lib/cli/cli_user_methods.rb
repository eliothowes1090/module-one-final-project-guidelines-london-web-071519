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
            until password == current_user.password
                puts "Incorrect password, please try again"
                password = PROMPT.ask("Please enter your password:", required: true)
            end
        current_user
    else 
        puts "Username not found please create a new Account!"
        current_user = create_new_user_account
    end
    current_user
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

def update_user_account(current_user)
    PROMPT.select("What would you like to update?") do |menu|
        menu.choice "Update your username", value: update_username(current_user)
        menu.choice "Update your password", value: update_password(current_user)
        menu.choice "Update your email", value: update_email(current_user)
        menu.choice "Return to home menu", value: decision_tree
    end
end

def update_username(current_user)
    current_user.update(user_name: PROMPT.ask("Input new username"))
end

def update_password(current_user)
    current_user.update(password: PROMPT.ask("Input new password"))
end

def update_email(current_user)
    current_user.update(email: PROMPT.ask("Input new email"))
end

def delete_user_account(current_user)
    puts "Your account has been deleted"
    current_user.delete
end

def search_for_concerts
    puts "Here is your concert"
end

def buy_ticket
    puts "You have bought a ticket"
end

def sell_ticket
    puts "You have sold ticket"
end

def logout
    puts "You have logged out"
end
