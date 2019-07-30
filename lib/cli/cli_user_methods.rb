# require_relative '/lib/models/user.rb'
# require_relative '../../config/environment'

# User specific methods

# require 'pry'

def user_login
    username = PROMPT.ask("Please enter your username:", required: true)
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

def decision_tree(current_user)
    options = [
        {"Update your user account" => -> do update_user_account(current_user) end},
        {"Delete your user account" => -> do delete_user_account(current_user) end},
        {"Search for concerts" => -> do search_for_concerts end},
        {"Buy ticket" => -> do buy_ticket end},
        {"Sell ticket" => -> do sell_ticket end},
        {"Logout" => -> do logout end} 
    ]
    PROMPT.select("What would you like to do?", options)
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
    options = [
        {"Update your username" => -> do update_username(current_user) end},
        {"Update your password" => -> do update_password(current_user) end},
        {"Update your email" => -> do update_email(current_user) end},
        {"Return to home menu" => -> do decision_tree(current_user) end}
    ]
    PROMPT.select("What would you like to update?", options) 
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
    sleep(2)
    current_user = login_type
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
    sleep(2)
    current_user = login_type
end
