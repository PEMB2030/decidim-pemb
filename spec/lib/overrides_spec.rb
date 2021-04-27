# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      # layouts
      "/app/views/layouts/decidim/_logo.html.erb" => "2713715db652c8107f1fe5f2c4d618b6",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "55a9ca723b65b8d9eadb714818a89bb3",
      "/app/views/layouts/decidim/_head_extra.html.erb" => "1b8237357754cf519f4e418135f78440",
      "/app/views/layouts/decidim/_social_media_links.html.erb" => "497ce000e2e646fb4fba373961410252",
      # mailer
      "/app/views/layouts/decidim/mailer.html.erb" => "5bbe335c1dfd02f8448af287328a49dc",
      # cells
      "/app/cells/decidim/content_blocks/how_to_participate/show.erb" => "a5051a3f34ef68ccb0d180d98dfcb7b4"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      # layouts
      "/app/views/layouts/decidim/_conference_hero.html.erb" => "80a466727d353089e21988a5c72e52bd",
      # views
      "/app/views/decidim/conferences/conference_speakers/index.html.erb" => "1fad20938241a4ce3fe5a183bafe164e",
      "/app/views/decidim/conferences/conferences/show.html.erb" => "746ca5f3192ba14095431691b766430a"
    }
  }
]

describe "Overriden files", type: :view do
  # rubocop:disable Rails/DynamicFindBy
  checksums.each do |item|
    spec = ::Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end
  # rubocop:enable Rails/DynamicFindBy

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
