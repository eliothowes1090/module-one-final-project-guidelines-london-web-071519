def organisation_login
    organisation_name = PROMPT.ask("Please enter your organisation:", required: true)
    if Concert.find_by(ogranisation = organisation_name)
        password = PROMPT.ask("Please enter your password:", required: true)
        return Concert.find_by(ogranisation: organisation_name, password: password)
    else 
        "Organisation not found please create a new Account!"
        create_new_organisation_account
    end
end

def create_new_organisation_account
    organisation_name = PROMPT.ask("Please enter an organisation name:")

    organisation_password = PROMPT.ask("Please create a password:")
     
    organisation_email = PROMPT.ask("Please enter an email address")

    Concert.create(organisation: organisation_name, password: organisation_password, email: organisation_email)
end