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
      "/app/views/layouts/decidim/_logo.html.erb" => "838a2da0760e86e1cc1c1bc1892e983a",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "5a842f3e880f24f49789ee2f72d96f60",
      "/app/views/layouts/decidim/_social_media_links.html.erb" => "3ef7284789e8df2ddf6d8760783c11ed",
      # mailer
      "/app/views/layouts/decidim/mailer.html.erb" => "23a555f9c674d7db4b0ea6582525e2d6",
      "/app/cells/decidim/newsletter_templates/basic_only_text/show.erb" => "7d9d4f2ab8897143fe66e8ac8db2cedb",
      "/app/cells/decidim/newsletter_templates/image_text_cta/show.erb" => "08881fe2df7d87db0497376b08821594",
      # cells
      "/app/cells/decidim/content_blocks/how_to_participate/show.erb" => "29b61692a10c6728ef794bc8a269658a"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      # views
      "/app/views/decidim/conferences/conference_speakers/index.html.erb" => "1b90dedf1bac2863f3f5ca8ea28e8e2f"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      # views
      "/app/views/decidim/meetings/meetings/show.html.erb" => "768c00157cf64aa37ab7aea827b3a68a"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
