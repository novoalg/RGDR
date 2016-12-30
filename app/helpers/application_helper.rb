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

    def has_access

#        logger.info "******************"
#        logger.info current_user
#        logger.info "******************"
        true
        if current_user.nil?
            flash[:error] = "You do not have permission to do that. Please log in"
            redirect_to login_path
        end
    end


end
