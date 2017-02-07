class UserMailer < ApplicationMailer
    default from: "rgdrtemp@gmail.com"
    require 'sendgrid-ruby'
    include SendGrid
    require 'json'

    def welcome_email(user)
        @user = user
        mail = Mail.new
        mail.from = Email.new(email: 'rgdrtemp@gmail.com')
        mail.subject = 'Registration Confirmation - Real Good Dog Rescue'
        personalization = Personalization.new
        personalization.to = Email.new(email: @user.email)
        personalization.substitutions = Substitution.new(key: "-fullname-", value: @user.full_name)
        personalization.substitutions = Substitution.new(key: "-confirmlink-", value: "#{link_to "Confirm Email", { controller: "users", action: "confirm_email", confirm_token: @user.confirm_token }}")
        personalization.substitutions = Substitution.new(key: "-profilesettings-", value: "#{link_to "Profile Settings", edit_user_path(@user)}")
        mail.template_id = "1cf09bc0-4dcb-4015-8fc7-ac179e726f85"
        mail.personalizations = personalization
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
        begin
            response = sg.client.mail._("send").post(request_body: mail.to_json)
        rescue Exception => e
            puts e.message
        end
        puts response.status_code
        puts response.body
        puts response.headers
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
                @user = user
                mail(to: user.email, subject: "Real Good Dog Rescue - #{blog.title}")
            end 
        end 
    end
end
