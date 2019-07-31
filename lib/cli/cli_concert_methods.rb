
def organisation_login
    # organisation_name = ask_for_organisation_name
    # organisation_password = ask_for_organisation_password
    organisation_name = PROMPT.ask("please enter your organisation:", required: true)
    organisation_password = PROMPT.ask("please enter your password:", required: true)

    until Concert.find_by organisation: organisation_name, password: organisation_password
        # current_organisation = Concert.find_by organisation: organisation_name
        if Concert.find_by organisation: organisation_name 
            current_organisation = Concert.find_by organisation: organisation_name
            until organisation_password == current_organisation.password
                puts "Organisation found. Please re-enter your organisation and password:"
                    organisation_name = PROMPT.ask("please enter your organisation:", required: true)
                    organisation_password = PROMPT.ask("please enter your password:", required: true)
                # organisation_name = ask_for_organisation_name
                # organisation_password = ask_for_organisation_password
                # failed_current_organisation = Concert.find_by organisation: organisation_name, password: organisation_password
            end
        else
            password = nil
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

def organisation_decision_tree
    options = [
        {"Create a concert" => -> do create_concert end},
        {"Cancel concert" => -> do "Cancel Concert"end},
        {"Increase concert capacity" => -> do "Increase capacity" end},
        {"Logout" => -> do logout end} 
    ]
    PROMPT.select("What would you like to do?", options)
end

def create_concert
    venue = PROMPT.ask("Add venue:", required: true)
    current_organisation.venue = venue
    artist = PROMPT.ask("Add an artist:", required: true)
    current_organisation.artist = artist
    no_of_ticket = PROMPT.ask("Add number of tickets:", required: true)
    current_organisation.no_of_tickets = no_of_tickets
    start_time = PROMPT.ask("Add a start time:", required: true)
    current_organisation.start_time = start_time
    end_time = PROMPT.ask("Add and end time:", required: true)
    current_organisation.end_time = end_time
end

def cancel_concert
    # current.organisation.delete(venue, artist)
end

def increase_concert_capacity

end




def logout
    puts "You have logged out"
    sleep(2)
    current_organisation = login_type
end
