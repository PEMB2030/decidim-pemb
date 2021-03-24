# frozen_string_literal: true

require_relative "script_helpers"

namespace :pemb do
  namespace :proposals do
    include ScriptHelpers

    task :import, [:component, :csv] => :environment do |_task, args|
      process_csv(args) do |params|
        attributes = normalize(params[:line]).merge(geolocate(attributes[:address]))
        attributes[:author] = organization
        attributes[:current_user] = admin
        attributes[:component] = component
        form = OpenStruct.new(attributes)

        Decidim::Proposals::Admin::CreateProposal.call(form) do
          on(:ok) do
            show_success("ANSWERED!")
          end
          on(:invalid) do
            show_error("NOT ANSWERED!")
          end
        end
      end
    end
  end
end
