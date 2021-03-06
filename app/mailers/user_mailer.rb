class UserMailer < ApplicationMailer
    #include ActionView::Helpers
    #include Rails.application.routes.url_helpers
    default from: "rgdrtemp@gmail.com"
    require 'sendgrid-ruby'
    include SendGrid
    require 'json'

    def welcome_email(user)
        @user = user
        if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
            mail(to: user.email, subject: "Registration Confirmation - Real Good Dog Rescue")
        else
            mail = Mail.new
            mail.from = Email.new(email: 'rgdrtemp@gmail.com')
            mail.subject = 'Registration Confirmation - Real Good Dog Rescue'
            personalization = Personalization.new
            personalization.to = Email.new(email: @user.email)
            personalization.substitutions = Substitution.new(key: "-fullname-", value: @user.full_name)
        personalization.substitutions = Substitution.new(key: "-confirmlink-", value: "#{Rails.application.routes.url_helpers.url_for(controller: 'users', action: 'confirm_email', confirm_token: @user.confirm_token, host: "realgooddogrescue.heroku.com")}")
            personalization.substitutions = Substitution.new(key: "-profilesettings-", value: "#{Rails.application.routes.url_helpers.url_for(controller: 'users', action: 'edit', id: @user.id, host: "realgooddogrescue.heroku.com")}")
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
    end 

    def adopt_email(form_params)
       email = form_params["Email"] 
       @params = form_params
       if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
            mail(to: email, subject: "Your adoption form has been submitted successfully - Real Good Dog Rescue")
       else
           sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
#don't email person who submitted form, in this case lisa will look over their information and email them back
=begin
           mail = Mail.new
           mail.from = Email.new(email: 'rgdrtemp@gmail.com')
           mail.subject = 'Your adoption form has been submitted successfully - Real Good Dog Rescue'
           personalization = Personalization.new
           personalization.to = Email.new(email: email)
           @form = ""
           @params.each do |k, v|
               @form << "<b>#{k}</b> <i>#{v}</i> <br>"
           end
           personalization.substitutions = Substitution.new(key: '-fullname-', value: "#{form_params['Your first name']} #{form_params['Your last name']}")
           personalization.substitutions = Substitution.new(key: '-form-', value: @form)
           mail.template_id ="65bda34b-13ad-4adb-84a9-2d69b22babbb"
           mail.personalizations = personalization
           begin 
                response = sg.client.mail._("send").post(request_body: mail.to_json)
           rescue Exception => e
                puts e.message
           end
           puts response.status_code
           puts response.body
           puts response.headers
=end

            #email to lisa 
           mail = Mail.new
           mail.from = Email.new(email: 'rgdrtemp@gmail.com')
           mail.subject = "#{form_params['Your first name']} #{form_params['Your last name']} has submitted an adoption form - Real Good Dog Rescue"
           personalization = Personalization.new
           personalization.to = Email.new(email: 'ltrenthem@gmail.com') 
           personalization.substitutions = Substitution.new(key: '-fullname-', value: "#{form_params['Your first name']} #{form_params['Your last name']}")
           personalization.substitutions = Substitution.new(key: '-form-', value: @form)
           mail.template_id = "a7ee96fd-8266-4215-9ed8-f189f0a1271e"
           mail.personalizations = personalization
           begin 
                response = sg.client.mail._("send").post(request_body: mail.to_json)
           rescue Exception => e
                puts e.message
           end
           puts response.status_code
           puts response.body
           puts response.headers

        end
    end

    def password_reset(user)
        @user = user
        if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
            mail(to: @user.email, subject: "Password Reset - Real Good Dog Rescue")
        else
            mail = Mail.new
            mail.from = Email.new(email: 'rgdrtemp@gmail.com')
            mail.subject = 'Password Reset - Real Good Dog Rescue'
            personalization = Personalization.new
            personalization.to = Email.new(email: user.email)
            personalization.substitutions = Substitution.new(key: '-fullname-', value: @user.full_name)
            personalization.substitutions = Substitution.new(key: '-resetlink-', value: "#{Rails.application.routes.url_helpers.url_for(controller: 'password_resets', action: 'edit', id: @user.reset_token, email: @user.email, host: 'realgooddogrescue.heroku.com')}")
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
        end

    end
    
    def contact_email(form)
        email = form["Email"]
        if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
            mail(to: "rgdrtemp@gmail.com", subject: "#{form['First Name']} #{form['Last Name']} has contacted you- Real Good Dog Rescue")
        else
            mail = Mail.new
            mail.from = Email.new(email: 'rgdrtemp@gmail.com')
            mail.subject = "#{form['First Name']} #{form['Last Name']} has contacted you - Real Good Dog Rescue"
            personalization = Personalization.new
            personalization.to = Email.new(email: 'ltrenthem@gmail.com') 
            personalization.substitutions = Substitution.new(key: '-fullname-', value: "#{form['First Name']} #{form['Last Name']}")
            personalization.substitutions = Substitution.new(key: '-fullnamesubject-', value: "#{form['First Name']} #{form['Last Name']}")
            @form = ""
            form.each do |k, v|
                @form << "#{k}: #{v} <br>"
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
    end

    def news_email(subbed_users, blog)
        @users = subbed_users
        @blog = blog
        if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
            if @users.any?
                @users.each do |user|
                    mail(to: user.email, subject: "#{blog.title} - Real Good Dog Rescue")
                end
            end
        else
            sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
            if @users.any?
                @users.each do |user|
                    @user = user
                    mail = Mail.new
                    mail.from = Email.new(email: 'rgdrtemp@gmail.com')
                    mail.subject = "#{blog.title} - Real Good Dog Rescue"
                    personalization = Personalization.new
                    personalization.to = Email.new(email: user.email)
                    personalization.substitutions = Substitution.new(key: '-title-', value: blog.title)
                    personalization.substitutions = Substitution.new(key: '-content-', value: blog.content)
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
                end 
            end 
        end
    end
end
