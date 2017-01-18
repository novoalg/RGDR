module ApplicationHelper
    include SessionsHelper
    def title(page_title)
      content_for :title, page_title.to_s
    end

    def bootstrap_class_for flash_type
        logger.info flash_type
        case flash_type
            when "success"
                "alert-success"
            when "error"
                "alert-danger"
            when "info"
                "alert-info"
            when "warning"
                "alert-warning"
            else
                flash_type.to_s
        end
    end

    def flash_messages(opts = {})
        flash.each do |msg_type, message|
            concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}", role: "alert") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
        end
        nil
    end

    #Same user showing editing/updating profile
    def same_user
        if current_user 
            if (current_user.id == params[:id].to_i) || (current_user.hierarchy < 1)
                true
            else
                if request.xhr?
                    flash[:error] = "You don't have permission to do that."
                    render :js => "window.location = '#{root_path}';"
                else
                    flash[:error] = "You don't have permission to do that."
                    redirect_to root_path
                end
            end 
        else
            flash[:error] = "You don't have permission to do that. Please log in"
            redirect_to login_path
        end
    end



    def has_access
        true
        if current_user.nil? 
            flash[:error] = "You do not have permission to do that. Please log in"
            redirect_to login_path
        end
    end

    def has_access_admin
        true
        if current_user.nil?
            flash[:error] = "You do not have permission to do that. Please log in"
            redirect_to login_path
        elsif current_user.hierarchy > 0
            flash[:error] = "You do not have permission to do that."
            redirect_to root_path
        end
    end

    def has_access_moderator
        true
        if current_user.nil?
            flash[:error] = "You do not have permission to do that. Please log in."
            redirect_to login_path
        elsif current_user.hierarchy > 1
            flash[:error] = "You do not have permission to do that."
            redirect_to root_path
        end
    end

    def banned_user
        true
        if current_user.banned
            flash[:error] = "You do not have permission to comment on news articles."
            redirect_to blogs_path
        end
    end
end
