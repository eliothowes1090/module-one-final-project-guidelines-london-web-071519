def welcome_message
    clear_console
    puts "                                                                                                                
    . . .     |                            |             --.--o     |         |             . . .     ,---.         
    | | |,---.|    ,---.,---.,-.-.,---.    |--- ,---.      |  .,---.|__/ ,---.|---     ,---.| | |,---.|---'         
    | | ||---'|    |    |   || | ||---'    |    |   |      |  ||    |  \ |---'|        `---.| | |,---||             
    `-'-'`---'`---'`---'`---'` ' '`---'    `---'`---'      `  ``---'`   ``---'`---'    `---'`-'-'`---^`             
                                                                                                                    
                                                                                                                    
                                                     /   ||   \                                                     
                                                    / ---||--- \                                                    
                                                    \ ---||--- /                                                    
                                                     \   ||   /                                                     
                                                                                                                    
                                                                                                                    
                        |             |    |             ,---.    |                            ,---.|    o     |    
    ,---.,---.,---.,---.|--- ,---.,---|    |---.,   .    |---|,---|,---.,---.,---.     ,-.     |--- |    .,---.|--- 
    |    |    |---',---||    |---'|   |    |   ||   |    |   ||   ||   |,---||   |     |_|_    |    |    ||   ||    
    `---'`    `---'`---^`---'`---'`---'    `---'`---|    `   '`---'`   '`---^`   '       |     `---'`---'``---'`---'
                                                `---'                                                               "
    sleep(3)                                            
end

def login_type
    options = [
        {"User Login" => -> do user_login end},
        {"Create new User Account" => -> do create_new_user_account end},
        {"Concert Login" => -> do organisation_login end},
        {"Create new Concert Account" => -> do create_new_organisation_account end},
        {"Exit Ticket Swap" => -> do exit_app end}   
    ]
    PROMPT.select("Please choose your login type or exit the app:", options) 
end

def exit_app
    puts "Thanks for using Ticket Swap"
    sleep(2)
    exit!
end

def clear_console
    print "\e[2J\e[f"
end