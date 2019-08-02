def organisation_login
    $organisation_name = PROMPT.ask("Please enter your organisation:", required: true)
    $organisation_password = PROMPT.mask("please enter your password:", required: true)

    until Concert.find_by organisation: $organisation_name, password: $organisation_password
        options = [
            {"Re-enter login details" => -> do ask_organisation_credentials end},
            {"Create new account" => -> do current_organisation = create_new_organisation_account end}
        ]
        PROMPT.select("Login Failed! Would you like to:", options)
    end
    current_organisation = Concert.find_by organisation: $organisation_name
    organisation_decision_tree(current_organisation)
end

def ask_organisation_credentials
    $organisation_name = PROMPT.ask("Please enter your organisation:", required: true)
    $organisation_password = PROMPT.mask("Please enter your password:", required: true)
end


def create_new_organisation_account
    organisation_name = ask_for_organisation_name
    while Concert.find_by organisation: organisation_name
        puts "Organisation already exists please create a new orgnisation."
        organisation_name = ask_for_organisation_name
    end
    
    organisation_password = ask_for_organisation_password
     
    organisation_email = ask_for_organisation_email
    while Concert.find_by email: organisation_email 
        puts "Email already exists please use another email."
        organisation_email = ask_for_organisation_email
    end
    Concert.create(organisation: organisation_name, password: organisation_password, email: organisation_email)
    current_organisation = Concert.find_by organisation: organisation_name
    organisation_decision_tree(current_organisation)
end

def organisation_decision_tree(current_organisation)
    options = [
        {"Create a concert" => -> do create_concert(current_organisation) end},
        {"Cancel concert" => -> do cancel_concert(current_organisation) end},
        {"Increase concert capacity" => -> do increase_concert_capacity(current_organisation) end},
        {"Logout" => -> do logout end} 
    ]
    PROMPT.select("What would you like to do?", options)
end

def ask_for_organisation_name
    PROMPT.ask("Please enter your organisation name:", required: true)
end

def ask_for_organisation_password
    PROMPT.mask("Please enter your organisation password:", required: true)
end

def ask_for_organisation_email
    PROMPT.ask("Please enter your organisation email:", required: true)
end

def create_concert(current_organisation)
    if current_organisation.venue
        puts "You have already organised a concert!"
        sleep(2)
        organisation_decision_tree(current_organisation)
    else
        venue = PROMPT.ask("Add venue:", required: true)
        current_organisation.venue = venue

        artist = PROMPT.ask("Add an artist:", required: true)
        current_organisation.artist = artist

        no_of_tickets = PROMPT.ask("Add number of tickets:", required: true)
        current_organisation.no_of_tickets = no_of_tickets
        create_tickets(current_organisation)

        start_time = PROMPT.ask("Add a start time:", required: true)
        current_organisation.start_time = start_time

        end_time = PROMPT.ask("Add and end time:", required: true)
        current_organisation.end_time = end_time

        current_organisation.save
        organisation_decision_tree(current_organisation)
    end
end

def create_tickets(current_organisation, increase_by = nil)
    ticket_price = PROMPT.ask("Please enter the cost of tickets:", require: true)
    if increase_by != nil
        increase_by.times do
            Ticket.create(price: ticket_price, concert_id: current_organisation.id)
        end
    else
        current_organisation.no_of_tickets.times do 
            Ticket.create(price: ticket_price, concert_id: current_organisation.id)
        end
    end
end

def cancel_concert(current_organisation)
    confirm_cancellation = PROMPT.yes?("Are you sure you want to cancel this concert?")
    if confirm_cancellation
        current_organisation.update(:venue => nil, :artist => nil, :no_of_tickets => nil, :start_time => nil, :end_time => nil)
        if Ticket.find_by concert_id: current_organisation.id
            Ticket.select{|ticket| ticket.concert_id == current_organisation.id}.count.times do
            to_delete = Ticket.find_by concert_id: current_organisation.id
            to_delete.delete
            end
        end
        organisation_decision_tree(current_organisation)
    elsif !confirm_cancellation
        organisation_decision_tree(current_organisation)
    end
end

def increase_concert_capacity(current_organisation)
    if Ticket.find_by concert_id: current_organisation.id
        increase_by = PROMPT.ask("How many tickets would you like to add for the concert?", require: true).to_i
        create_tickets(current_organisation, increase_by)
        current_organisation.no_of_tickets += increase_by.to_i
        current_organisation.save
        organisation_decision_tree(current_organisation)
    else
        puts "You haven't created a concert yet!"
        sleep(2)
        organisation_decision_tree(current_organisation)
    end
end

def logout
    puts "You have logged out"
    sleep(2)
    current_organisation = login_type
end
