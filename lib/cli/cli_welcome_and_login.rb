def welcome_message
    puts "Welcome to Ticket Swap"
end

def login_type
    PROMPT.select("Please choose your login type:") do |menu|
        menu.choice "User Login"
        menu.choice "Create new User Account"
        menu.choice "Concert Login"
        menu.choice "Create new Concert Account"
    end
end
