# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "~> 0.26.5"

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-access_codes", git: "https://github.com/Platoniq/decidim-module-access_codes", branch: "main"
gem "decidim-decidim_awesome", git: "https://github.com/decidim-ice/decidim-module-decidim_awesome"
gem "decidim-notify", "~> 0.5"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: "release/0.26-stable"

gem "bootsnap", "~> 1.7"
gem "deface"
gem "puma", ">= 5.0.0"

gem "wicked_pdf", "~> 2.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "faker", "~> 2.14"
  gem "rubocop-faker"

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "listen", "~> 3.1"
  gem "spring", ">= 4.0.0"
  gem "spring-watcher-listen", "~> 2.1"
  gem "web-console"
  # Profiling gems
  gem "bullet"
  gem "flamegraph"
  gem "memory_profiler"
  gem "rack-mini-profiler", require: false
  gem "stackprof"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "sidekiq"
  gem "sidekiq-cron"
end
