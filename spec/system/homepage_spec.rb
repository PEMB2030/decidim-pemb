# frozen_string_literal: true

require "rails_helper"

describe "Homepage" do
  let(:organization) { create :organization, twitter_handler: "pembarcelona" }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path(locale: "ca")
  end

  it "renders the home page" do
    expect(page).to have_content("Inici")
  end

  it "has custom logos" do
    expect(page).to have_css("img[src*='images/logo_conjunt']")
    expect(page).to have_css("img[src*='images/logo_pemb']")
    expect(page).to have_css("img[src*='images/logo_diba']")
    expect(page).to have_css(".pokecode-logo")
    expect(page).to have_css("img[src*='images/logo_pokecode']")
  end

  it "has custom social media links" do
    expect(page).to have_link(nil, href: "https://twitter.com/pembarcelona")
    expect(page).to have_link(nil, href: "/link?external_url=https%3A%2F%2Fwww.linkedin.com%2Fcompany%2F11257078")
  end
end
