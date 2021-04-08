# frozen_string_literal: true

Decidim::Verifications.register_workflow(:actors) do |workflow|
  workflow.engine = Decidim::AccessRequests::Verification::Engine
  workflow.admin_engine = Decidim::AccessRequests::Verification::AdminEngine
  workflow.renewable = true
  workflow.time_between_renewals = 5.minutes
end
