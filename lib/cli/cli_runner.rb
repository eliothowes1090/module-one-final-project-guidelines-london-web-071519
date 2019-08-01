require_relative 'cli_user_methods.rb'
require_relative 'cli_concert_methods.rb'
require_relative 'cli_welcome_login_and_exit.rb'


    def run
        welcome_message
        output = login_type

            if output.class == User
                user_decision_tree(output)
            elsif output.class == Concert
                organisation_decision_tree(output)
            end

        # binding.pry
        # current_user_or_organisation = login_type

        # puts current_user_or_organisation
# binding.pry
        # if current_user_or_organisation == Concert

        # current_user_decision = decision_tree(current_user)
        #     until current_user_decision == "Logout"
        #         decision_tree(current_user)
        #     end
        # end
    end