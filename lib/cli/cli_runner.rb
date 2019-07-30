require_relative 'cli_user_methods.rb'
require_relative 'cli_concert_methods.rb'
require_relative 'cli_welcome_and_login.rb'

def cli_runner
    welcome_message

    inputted_login_type = login_type
    if inputted_login_type == "User Login"
       current_user =  user_login
    elsif inputted_login_type == "Create new User Account"
        create_new_user_account
    elsif inputted_login_type == "Concert Login"
        organisation_login
    elsif inputted_login_type == "Create new Concert Account"
        create_new_organisation_account
    end

    current_user_decision = decision_tree
    until current_user_decision == "Logout" 
        # decision_tree
        if current_user_decision == "Update your user account"
            update_user_account(current_user)
        elsif current_user_decision == "Delete your user account"
            delete_user_account(current_user)
            welcome_message
            inputted_login_type = login_type
        elsif current_user_decision == "Search for concerts"
            search_for_concerts
        elsif current_user_decision == "Buy ticket"
            buy_ticket
        elsif current_user_decision == "Sell ticket"
            sell_ticket
        end
    end
    logout
    current_user = nil

end