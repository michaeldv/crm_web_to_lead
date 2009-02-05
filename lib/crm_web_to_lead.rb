class AppCallback < FatFreeCRM::Callback::Base

  # Implements application's before_filter hook.
  #----------------------------------------------------------------------------
  def app_before_filter(controller, context = {})
  
    # Only trap leads/create.
    return unless controller.controller_name == "leads" && controller.action_name == "create"
  
    # Remote form should POST two hidden fields to identify the user who'll own the lead:
    # 
    # <input type="hidden" name="authorization" value="<<< password_hash here >>>">
    # <input type="hidden" name="token" value="<<< password_token here >>>">
    #
    if controller.request.post? && !controller.params[:authorization].blank? && !controller.params[:token].blank?
      @current_user = User.find_by_password_hash_and_password_salt(controller.params[:authorization], controller.params[:token])
      controller.logger.info ">>> web-to-lead: creating lead for user " + @current_user.inspect
    end
  end

  # Implements application's after_filter hook.
  #----------------------------------------------------------------------------
  def app_after_filter(controller, context = {})

    # Only trap leads/create.
    return unless controller.controller_name == "leads" && controller.action_name == "create"

    # Two more hidden fields specify redirection URLs:
    #
    # <input type="hidden" name="on_success" value="<<< success URL here >>>"
    # <input type="hidden" name="on_success" value="<<< failure URL here >>>"
    #
    unless flash[:notice].blank? # Lead ... was successfully created.
      redirect_to(controller.params[:on_success]) unless controller.params[:on_success].blank?
    else
      redirect_to(controller.params[:on_failure]) unless controller.params[:on_failure].blank?
    end
  end

end