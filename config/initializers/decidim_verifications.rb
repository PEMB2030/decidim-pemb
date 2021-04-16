# frozen_string_literal: true

Decidim::Verifications.register_workflow(:access_codes) do |workflow|
  workflow.engine = Decidim::AccessCodes::Verification::Engine
  workflow.admin_engine = Decidim::AccessCodes::Verification::AdminEngine
  workflow.renewable = true
  workflow.time_between_renewals = 5.minutes
end
