module SessionsHelper

    def log_in(user)
        session[:user_id] = user.id
    end

    def current_user
        if (user_id = session[:user_id]) #equivalent of: user_id = session[:user_id]; if user_id
            @current_user ||= User.find_by(id: session[:user_id])
        elsif (user_id = cookies.signed[:user_id]) 
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    def logged_in?
        !current_user.nil?
    end

    def admin?
        current_user.hierarchy == 0
    end

    def moderator?
        current_user.hierarchy == 1
    end

    def member?
        current_user.hierarchy == 2    
    end


    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end

    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def confirm(user)
        user.confirm
        cookies.permanent[:confirm_token] = user.confirm_token
    end

    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end
end
