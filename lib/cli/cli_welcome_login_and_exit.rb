def welcome_message
    puts "Welcome to Ticket Swap"
end

def login_type
    options = [
        {"User Login" => -> do user_login end},
        {"Create new User Account" => -> do create_new_user_account end},
        {"Concert Login" => -> do organisation_login end},
        {"Create new Concert Account" => -> do create_new_organisation_account end},
        {"Exit Ticket Swap" => -> do exit_app end}   
    ]
    PROMPT.select("Please choose your login type or exit the app:", options) 
end

def exit_app
    p "Thanks for using Ticket Swap"
    sleep(2)
    exit!
end
