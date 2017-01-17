class UserMailer < ApplicationMailer
    default from: "gmail.com"

    def welcome_email(user)
        @user = user
        mail(to: @user.email, subject: "Registration Confirmation - Real Good Dog Rescue")
    end 
    def adopt_email
        
    end
end
