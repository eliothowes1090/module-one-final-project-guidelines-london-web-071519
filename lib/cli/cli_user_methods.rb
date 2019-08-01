def user_login
    username = PROMPT.ask("Please enter your username:", required: true)
    password = PROMPT.mask("Please enter your password:", required: true)
    until User.find_by user_name: username, password: password
        if User.find_by user_name: username
            current_user = User.find_by user_name: username
                until password == current_user.password
                    puts "Username found. Please re-enter your username and password:"
                    username = PROMPT.ask("Please enter your username:", required: true)
                    password = PROMPT.mask("Please enter your password:", required: true)
                end
        else 
            # password = nil
            options = [
            {"Re-enter username" => -> do username = PROMPT.ask("Please enter your username:", required: true) end},
            {"Create new account" => -> do current_user = create_new_user_account end}
            ]
            PROMPT.select("Username not found. Would you like to?", options)
        end
        failed_current_user = User.find_by user_name: username, password: password
        return failed_current_user
    end
    current_user = User.find_by user_name: username, password: password
end

def user_decision_tree(current_user)
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
    user_fullname = PROMPT.ask("Please enter your full name:", required: true)
    
    user_age = PROMPT.ask("Please enter your age (in years):", required: true)
        if user_age.to_i < 18
            puts "Sorry. You have to 18 or older to use Ticket Swap!"
            sleep(2)
            exit!
        end
     
    user_username = PROMPT.ask("Please create a new username:", required: true)
        while User.find_by user_name: user_username
            puts "Username already exists. Please enter a new username!"
            user_username = PROMPT.ask("Please create a new username:", required: true)
        end
     
    user_password = PROMPT.mask("Please create a password:", required: true)
        
     
    user_email = PROMPT.ask("Please enter your email address", required: true)
        while User.find_by email: user_email
            puts "Email already exists. Please enter a new email!"
            user_email = PROMPT.ask("Please enter your email address", required: true)
        end

    User.create(user_name: user_username, name: user_fullname, age: user_age.to_i, email: user_email, password: user_password)
end

def update_user_account(current_user)
    puts "Username: #{current_user.user_name}" 
    puts "Email: #{current_user.email}"
    options = [
        {"Update your username" => -> do update_username(current_user) end},
        {"Update your password" => -> do update_password(current_user) end},
        {"Update your email" => -> do update_email(current_user) end},
        {"Return to home menu" => -> do user_decision_tree(current_user) end}
    ]
    PROMPT.select("What would you like to update?", options) 
end

def update_username(current_user)
    new_user_name = PROMPT.ask("Input new username", required: true)
    while User.find_by user_name: new_user_name
        puts "Username already exists. Please enter a new username!"
        new_user_name = PROMPT.ask("Input new username", required: true)
    end

    current_user.update(user_name: new_user_name)
end

def update_password(current_user)
    current_user.update(password: PROMPT.ask("Input new password", required: true))
end

def update_email(current_user)
    new_email = PROMPT.ask("Input new email", required: true)
    while User.find_by email: new_email
        puts "Email already exists. Please enter a new email!"
        new_email = PROMPT.ask("Input new email", required: true)
    end

    current_user.update(email: new_email)
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
