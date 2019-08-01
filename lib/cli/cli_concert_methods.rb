
def organisation_login
    # organisation_name = ask_for_organisation_name
    # organisation_password = ask_for_organisation_password
    organisation_name = PROMPT.ask("Please enter your organisation:", required: true)
    organisation_password = PROMPT.mask("please enter your password:", required: true)

    until Concert.find_by organisation: organisation_name, password: organisation_password
        if Concert.find_by organisation: organisation_name 
            current_organisation = Concert.find_by organisation: organisation_name
            until organisation_password == current_organisation.password
                puts "Organisation found. Please re-enter your organisation and password:"
                    organisation_name = PROMPT.ask("please enter your organisation:", required: true)
                    organisation_password = PROMPT.mask("please enter your password:", required: true)
            end
        else
            # organisation_password = nil
            options = [
            {"Re-enter organisation" => -> do organisation_name = PROMPT.ask("please enter your organisation:", required: true) end},
            {"Create new organisation" => -> do current_organisation = create_new_organisation_account end}
            ]
            PROMPT.select("Organisation not found. Would you like to?", options)
        end
        failed_current_organisation = Concert.find_by organisation: organisation_name, password: organisation_password
        return failed_current_organisation
    end
    current_organisation = Concert.find_by organisation: organisation_name, password: organisation_password
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

def organisation_validation(organisation_name)
    until Concert.find_by organisation: organisation_name 
        options = [
        {"Re-enter organisation name:" => -> do organisation_name = ask_for_organisation_name end},
        {"Create new organisation account:" => -> do create_new_organisation_account end}
        ]
        PROMPT.select("Organisation not found. Please re-enter your organisation name or create a new organisation account:", options)
    end
end

def password_validation(organisation_password)
    until Concert.find_by password: organisation_password
        options = [
            {"Re-enter organisation password:" => -> do ask_for_organisation_password end},
            {"Create new organisation account:" => -> do create_new_organisation_account end}
        ]
        PROMPT.select("Password not found. Please re-enter your password or create a new organisation account:", options)
    end
end

def email_validation(organisation_email)
    until Concert.find_by email: organisation_email
        puts "Email already exists. Please enter a new email:"
        organisation_email = sk_for_organisation_email
    end
end

def create_concert(current_organisation)
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

def create_tickets(current_organisation, increase_by = nil)
    ticket_price = PROMPT.ask("Please enter the cost of tickets:", require: true)
    if Concert.find_by venue: current_organisation.venue
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
            Ticket.count.times do
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
        # binding.pry
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
