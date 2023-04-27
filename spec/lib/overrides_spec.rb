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
      "/app/views/layouts/decidim/_logo.html.erb" => "ab01dd1df9ce62cbd62f640a3b5018b2",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "5a842f3e880f24f49789ee2f72d96f60",
      "/app/views/layouts/decidim/_social_media_links.html.erb" => "497ce000e2e646fb4fba373961410252",
      # mailer
      "/app/views/layouts/decidim/mailer.html.erb" => "0c7804de08649c8d3c55c117005e51c9",
      "/app/cells/decidim/newsletter_templates/basic_only_text/show.erb" => "6f85f6b733a6db3b11f9cabb19ae4126",
      "/app/cells/decidim/newsletter_templates/image_text_cta/show.erb" => "606f899f03d5e4e6d3c1691132eeb2ac",
      # cells
      "/app/cells/decidim/content_blocks/how_to_participate/show.erb" => "3ee6aac33019962ad875c07fdba41b05"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      # views
      "/app/views/decidim/conferences/conference_speakers/index.html.erb" => "1fad20938241a4ce3fe5a183bafe164e"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      # views
      "/app/views/decidim/meetings/meetings/show.html.erb" => "d0f2ec43188acab470151f40294bdbc8"
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
