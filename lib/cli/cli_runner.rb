require_relative 'cli_user_methods.rb'
require_relative 'cli_concert_methods.rb'
require_relative 'cli_welcome_login_and_exit.rb'


    def run
        welcome_message
        output = login_type
   
            if output.class == User
                puts "#{output.name} is logged in"
                sleep(2)
                user_decision_tree(output)
            elsif output.class == Concert
                puts "#{output.organisation} is logged in"
                organisation_decision_tree(output)
            end
    end

    