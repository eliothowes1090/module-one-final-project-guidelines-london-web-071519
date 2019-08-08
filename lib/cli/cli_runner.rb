require_relative 'cli_user_methods.rb'
require_relative 'cli_concert_methods.rb'
require_relative 'cli_welcome_login_and_exit.rb'


    def run
        welcome_message
        output = login_type
    end

    # Need to refactor code so that CLI (concert_methods, user_methods and welcome_loging_and_exit) are in classes
    # This will require that each method stops passing in the current user and instead uses an instance variable.
    # Finally need to refactor cli_runner so that this method is what control the flow of the app rather than the actualy methods callig eachother.
    