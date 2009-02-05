RAILS_DEFAULT_LOGGER.info ">> Adding web-to-lead Fat Free CRM plugin..."

FatFreeCRM::Plugin. << :web_to_lead do # Same as FatFreeCRM::Plugin.add(:web_to_lead) do
         name "Web-to-lead Capture Fat Free CRM Plugin"
       author "Michael Dvorkin"
      version "1.0"
  description "Create Fat Free CRM leads from the data submitted via remote web form."
end

require "crm_web_to_lead.rb"