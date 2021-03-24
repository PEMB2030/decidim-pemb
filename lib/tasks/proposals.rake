# frozen_string_literal: true

require_relative "script_helpers"

namespace :pemb do
  namespace :proposals do
    include ScriptHelpers

    task :import, [:component, :csv] => :environment do |_task, args|
      process_csv(args) do |params|
        attributes = normalize(params[:line])
        location = geolocate(attributes[:address]);
        raise UnprocessableError, "Cannot be processed" unless location

        attributes.merge!(location)
        proposal = Decidim::Proposals::Proposal.find_by(title: { ca: attributes[:title][:ca] })
        raise UnprocessableError, "Proposal [#{proposal.id}] already processed!" if proposal

        attributes[:author] = params[:component].organization
        attributes[:current_organization] = params[:component].organization
        attributes[:current_user] = params[:admin]
        attributes[:component] = params[:component]
        attributes[:current_component] = params[:component]
        form = OpenStruct.new(attributes)

        Decidim::Proposals::Admin::CreateProposal.call(form) do
          on(:ok) do |proposal|
            show_success("#{proposal.id} #{proposal.title} CREATED!")
          end
          on(:invalid) do
            show_error("NOT CREATED!")
          end
        end
      end
    end
  end
end
