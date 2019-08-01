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
        {"See upcoming concerts and buy a ticket" => -> do buy_ticket(current_user) end},
        {"See my tickets" => -> do see_my_tickets(current_user) end},
        {"Sell ticket" => -> do sell_ticket(current_user) end},
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
    confirm_cancellation = PROMPT.yes?("Are you sure you want to delete your user account?")
    if confirm_cancellation
            if Ticket.find_by user_id: current_user.id
                Ticket.count.times do
                    to_delete = Ticket.find_by user_id: current_user.id
                    to_delete.delete
                end
            end
        puts "Your account has been deleted"
        sleep(2)
        current_user.delete 
        current_user = login_type
    elsif !confirm_cancellation
        user_decision_tree(current_user)
    end
    
    # sleep(2)
    # current_user = login_type
end

def convert_obj_to_string(obj)
    string = " - - -> Concert Venue: #{obj.venue} - - - Artist: #{obj.artist} - - - Tickets Available: #{obj.no_of_tickets} - - - Start Time: #{obj.start_time} - - - End Time #{obj.end_time} <- - - "
end

def search_for_concerts
    puts "Here are the upcoming concerts"
    up_coming_concerts = Concert.all.where.not(venue: nil)
    # list_of_concerts = Concert.all.where.not(venue: nil)
    # array_of_obj_and_strings = {}
        
    # list_of_concerts.each do |concert|
    #     array_of_obj_and_strings[concert] = convert_obj_to_string(concert)
    # end
    
    # selection = PROMPT.select("Please select a concert:", array_of_obj_and_strings.values)
    # output = array_of_obj_and_strings.key(selection)
    # output
    up_coming_concerts
end

def select_concert(search_for_concerts, current_user)
    array_of_obj_and_strings = {}
        
    search_for_concerts.each do |concert|
        array_of_obj_and_strings[concert] = convert_obj_to_string(concert)
    end
    
    selection = PROMPT.select("Please select a concert:", array_of_obj_and_strings.values)
    output = array_of_obj_and_strings.key(selection)
    output
end

def buy_ticket(current_user)
    if !Ticket.all
        puts "Sorry there are no upcoming concerts!"
        sleep(2)
        user_decision_tree(current_user)
    else 
        # puts "Which concert would you like to buy a ticket for?"
        concert_selection = select_concert(search_for_concerts, current_user)
        selected_concert_id = concert_selection.id
        # binding.pry
        # need to add in concert_id that matches above
        if Ticket.find_by user_id: nil, concert_id: selected_concert_id
            first_unsold_ticket = Ticket.find_by user_id: nil, concert_id: selected_concert_id
            first_unsold_ticket.update user_id: current_user.id
            user_decision_tree(current_user)
        else
            puts "There are no tickets left for that concert!"
            sleep(2)
            user_decision_tree(current_user)
        end
    end
    # user_decision_tree(current_user)
end

def see_my_tickets(current_user)
    if Ticket.find_by user_id: current_user.id
        my_tickets = Ticket.select {|ticket| ticket.user_id == current_user.id}
        my_tickets.each {|ticket| p convert_ticket_to_string(ticket)}
        return_to_home = PROMPT.yes?("Do you want to return to the user menu?")
        until return_to_home == true
            my_tickets
            return_to_home = PROMPT.yes?("Do you want to return to the user menu?")
        end
        my_tickets
        user_decision_tree(current_user)
    else
        puts "You have no tickets!"
        sleep(2)
        user_decision_tree(current_user)
    end
end

def users_tickets(current_user)
    Ticket.select {|ticket| ticket.user_id == current_user.id}
end

def convert_ticket_to_string(obj)
    string = " - - -> Concert Venue: #{(Concert.find_by(id: obj.concert_id)).venue} - - - Artist: #{Concert.find_by(id: obj.concert_id).artist} - - - Price: #{obj.price} <- - - "
end

def select_ticket(current_user)
    array_of_obj_and_strings = {}
        
    users_tickets(current_user).each do |ticket|
        array_of_obj_and_strings[ticket] = convert_ticket_to_string(ticket)
    end
    selection = PROMPT.select("Please select a ticket to sell:", array_of_obj_and_strings.values)
    output = array_of_obj_and_strings.key(selection)
    output
end

def sell_ticket(current_user)
    # puts "For which concert would you like to sell your ticket?"
    # concert_to_sell_ticket_for = nil
    # first_owned_ticket_that_matches_concert = Ticket.find_by user_id: current_user.id, concert_id: 
    if Ticket.includes(user_id: current_user.id)
        ticket_to_sell = select_ticket(current_user)
        ticket_to_sell.user_id = nil
        ticket_to_sell.save
        # binding.pry
        # test = Ticket.select {|ticket| ticket.user_id == current_user.id}
        user_decision_tree(current_user)
    else
        puts "You have no tickets!"
        sleep(2)
        user_decision_tree(current_user)
    end
end

def logout
    puts "You have logged out"
    sleep(2)
    current_user = login_type
end
