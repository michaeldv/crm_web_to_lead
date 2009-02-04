class AppCallback < FatFreeCRM::Callback::Base

  # Implement application's before_filter hook.
  #----------------------------------------------------------------------------
  def app_before_filter(controller, context = {})
  
    # Only trap leads/create.
    return unless controller.controller_name == "leads" && controller.action_name == "create"
  
    # Remote form should POST two hidden fields to identify the user who'll own the lead:
    # 
    # <input type="hidden" name="authorization" value="<<< User's password_hash Here >>>"
    # <input type="hidden" name="token" value="<<< User's password_token Here >>>"
    #
    if controller.request.post? && !controller.params[:authorization].blank? && !controller.params[:token].blank?
      @current_user = User.find_by_password_hash_and_password_salt(controller.params[:authorization], controller.params[:token])
      controller.logger.info ">>> web-to-lead: creating lead for user " + @current_user.inspect
    end
  end

end