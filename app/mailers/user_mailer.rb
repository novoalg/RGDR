class UserMailer < ApplicationMailer
    #include ActionView::Helpers
    #include Rails.application.routes.url_helpers
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
        if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
            personalization.substitutions = Substitution.new(key: "-confirmlink-", value: "#{Rails.application.routes.url_helpers.url_for(controller: 'users', action: 'confirm_email', confirm_token: @user.confirm_token, host: "localhost:3000")}")
            personalization.substitutions = Substitution.new(key: "-profilesettings-", value: "#{Rails.application.routes.url_helpers.url_for(controller: 'users', action: 'edit', id: @user.id, host: "localhost:3000")}")
        else
            personalization.substitutions = Substitution.new(key: "-confirmlink-", value: "#{Rails.application.routes.url_helpers.url_for(controller: 'users', action: 'confirm_email', confirm_token: @user.confirm_token, host: "realgooddogrescue.heroku.com")}")
            personalization.substitutions = Substitution.new(key: "-profilesettings-", value: "#{Rails.application.routes.url_helpers.url_for(controller: 'users', action: 'edit', id: @user.id, host: "realgooddogrescue.heroku.com")}")
        end
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
       email = form_params["Email"] 
       @params = form_params
       mail = Mail.new
       mail.from = Email.new(email: 'rgdrtemp@gmail.com')
       mail.subject = 'Your adoption form has been submitted successfully - Real Good Dog Rescue'
       personalization = Personalization.new
       personalization.to = Email.new(email: email)
       @form = ""
       @params.each do |k, v|
           @form << "#{k}: #{v} </br>"
       end
       personalization.substitutions = Substitution.new(key: '-fullname-', value: "#{form_params[1]} #{form_params[2]}")
       personalization.substitutions = Substitution.new(key: '-form-', value: @form)
       mail.template_id ="65bda34b-13ad-4adb-84a9-2d69b22babbb"
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
       #mail(to: email, subject: "Your adoption form has been submitted successfully - Real Good Dog Rescue")
    end

    def password_reset(user)
        @user = user
        mail = Mail.new
        mail.from = Email.new(email: 'rgdrtemp@gmail.com')
        mail.subject = 'Password Reset - Real Good Dog Rescue'
        personalization = Personalization.new
        personalization.to = Email.new(email: email)
        personalization.substitutions = Substitution.new(key: '-fullname-', value: "#{form_params[1]} #{form_params[2]}")
        personalization.substitutions = Substitution.new(key: '-resetlink-', "#{Rails.application.routes.url_helpers.url_for(controller: 'password_resets', action: 'edit', reset_token: @user.reset_token, email: @user.email, host: "realgooddogrescue.heroku.com")}")
        mail.template_id ="ffb64a81-578d-4d62-82e1-cd0790f40176"
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

        #mail(to: @user.email, subject: "Password Reset - Real Good Dog Rescue")
    end
    
    def contact_email(form)
        email = form["Email"]
        mail = Mail.new
        mail.from = Email.new(email: 'rgdrtemp@gmail.com')
        mail.subject = "#{form['First Name']} #{form['Last Name']} has contacted you - Real Good Dog Rescue"
        personalization = Personalization.new
        personalization.to = Email.new(email: 'rgdrtemp@gmail.com') #change to lisa's email once it works
        personalization.substitutions = Substitution.new(key: '-fullname-', value: "#{form["First Name"]} #{form["Last Name"]}")
        @form = ""
        form.each do |k, v|
            @form << "#{k}: #{v} </br>"
        end
        personalization.substitutions = Substitution.new(key: '-form-', value: @form)
        mail.template_id = "11aae390-cbe3-4b6f-88b8-81a26b1c94c9"
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

    def news_email(subbed_users, blog)
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
        @users = subbed_users
        @blog = blog
        if @users.any?
            @users.each do |user|
                @user = user
                mail = Mail.new
                mail.from = Email.new(email: 'rgdrtemp@gmail.com')
                mail.subject = "#{blog.title} - Real Good Dog Rescue"
                personalization = Personalization.new
                personalization.to = Email.new(email: user.email)
                personalization.substitutions = Substitution.new(key: '-title-', value: blog.title)
                personalization.substitutions = Substitution.new(key: '-content-', value: raw(blog.content))
                personalization.substitutions = Substitution.new(key: '-bloglink-', value: "#{Rails.application.routes.url_helpers.url_for(controller: 'blogs', action: 'show', id: blog.id, host: "realgooddogrescue.heroku.com")}")
                personalization.substitutions = Substitution.new(key: "-profilesettings-", value: "#{Rails.application.routes.url_helpers.url_for(controller: 'users', action: 'edit', id: user.id, host: "realgooddogrescue.heroku.com")}")

                mail.template_id = "9127fe16-dff8-42b4-9c24-afeb978f249d"
                mail.personalizations = personalization
                begin 
                    response = sg.client.mail._("send").post(request_body: mail.to_json)
                rescue Exception => e
                    puts e.message
                end
                puts response.status_code
                puts response.body
                puts response.headers


                #mail(to: user.email, subject: "Real Good Dog Rescue - #{blog.title}")
            end 
        end 
    end
end
