require_relative 'cli_user_methods.rb'
require_relative 'cli_concert_methods.rb'
require_relative 'cli_welcome_login_and_exit.rb'

def cli_runner
    welcome_message

    current_user = login_type

    current_user_decision = decision_tree(current_user)
        until current_user_decision == "Logout"
            decision_tree(current_user)
        end
end