class UserMailer < ApplicationMailer
    default from: "rgdrtemp@gmail.com"

    def welcome_email(user)
        @user = user
        mail(to: @user.email, subject: "Registration Confirmation - Real Good Dog Rescue")
    end 

    def adopt_email(form_params)
       email = form_params["email"] 
       @params = form_params
       mail(to: email, subject: "Your adoption form has been submitted successfully - Real Good Dog Rescue")
    end

    def password_reset(user)
        @user = user
        mail(to: @user.email, subject: "Password Reset - Real Good Dog Rescue")
    end

    def news_email(subbed_users, blog)
        @users = subbed_users
        @blog = blog
        if @users.any?
            @users.each do |user|
                mail(to: @user.email, subject: "Real Good Dog Rescue - #{blog.title}")
            end 
        end 
    end
end
