# frozen_string_literal: true

# lib/tasks/rebuild_metrics.rake
namespace :pemb do
  desc "Rebuild metrics"
  task rebuild_metrics: :environment do
    days = (Date.parse(2.years.ago.to_s)..Date.yesterday).uniq
    metrics = {
      "participants" => Decidim::Metrics::ParticipantsMetricManage,
      "followers" => Decidim::Metrics::FollowersMetricManage,
      "participatory_processes" => Decidim::ParticipatoryProcesses::Metrics::ParticipatoryProcessesMetricManage,
      "assemblies" => Decidim::Assemblies::Metrics::AssembliesMetricManage,
      "comments" => Decidim::Comments::Metrics::CommentsMetricManage,
      "meetings" => Decidim::Meetings::Metrics::MeetingsMetricManage,
      "proposals" => Decidim::Proposals::Metrics::ProposalsMetricManage,
      "accepted_proposals" => Decidim::Proposals::Metrics::AcceptedProposalsMetricManage,
      "votes" => Decidim::Proposals::Metrics::VotesMetricManage,
      "endorsements" => Decidim::Proposals::Metrics::EndorsementsMetricManage,
      "survey_answers" => Decidim::Surveys::Metrics::AnswersMetricManage,
      "results" => Decidim::Accountability::Metrics::ResultsMetricManage,
      "debates" => Decidim::Debates::Metrics::DebatesMetricManage
    }
    Decidim::Organization.find_each do |org|
      metrics.each do |key, klass|
        old_metrics = Decidim::Metric.where(organization: org).where(metric_type: key)
        days.each do |day|
          new_metrics = klass.new(day.to_s, org)
          ActiveRecord::Base.transaction do
            old_metrics.where(day: day).delete_all
            new_metrics.save
          end
        end
      end
    end
  end

  desc "Test email server"
  task :mail_test, [:email] => :environment do |_task, args|
    raise ArgumentError if args.email.blank?

    puts "Sending a test email to #{args.email}"

    if ENV["SMTP_SETTINGS"].present?
      settings_string = ENV["SMTP_SETTINGS"].gsub(/(\w+)\s*:/, '"\1":').gsub("\\", "").gsub("'", "")
      settings = JSON.parse(settings_string).to_h
      ActionMailer::Base.smtp_settings = settings
      puts "Using custom settings!"
    end
    puts "Using configuration:"
    puts ActionMailer::Base.smtp_settings

    mail = ActionMailer::Base.mail(to: args.email,
                                   from: Decidim.mailer_sender,
                                   subject: "A test mail from #{Decidim.application_name}",
                                   body: "Sent by #{ENV.fetch("LOGNAME", nil)} in #{ENV.fetch("HOME", nil)} at #{Date.current}")
    mail.deliver_now
  rescue ArgumentError
    puts mail_usage
  end

  def mail_usage
    "Usage:
bin/rails 'pemb:mail_test[email@example.org]'

Override default configuration with the ENV var SMTP_SETTINGS:

export SMTP_SETTINGS='{address: \"stmp.example.org\", port: 25, enable_starttls_auto: true}'
"
  end
end
