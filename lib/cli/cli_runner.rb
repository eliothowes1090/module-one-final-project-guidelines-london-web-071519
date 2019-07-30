require_relative 'cli_user_methods.rb'
require_relative 'cli_concert_methods.rb'
require_relative 'cli_welcome_and_login.rb'

def cli_runner
    welcome_message
    inputted_login_type = login_type
    if inputted_login_type == "User Login"
        user_login
    elsif inputted_login_type == "Create new User Account"
        create_new_user_account
    elsif inputted_login_type == "Concert Login"
        organisation_login
    elsif inputted_login_type == "Create new Concert Account"
        create_new_organisation_account
    end

end