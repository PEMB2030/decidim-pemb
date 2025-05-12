# frozen_string_literal: true

require "rails_helper"

describe "When_visiting_a_meeting" do
  let(:organization) { create :organization }
  let(:user) { create(:user, :confirmed, organization:) }
  let(:participatory_process) { create(:participatory_process, organization:) }
  let(:component) { create(:meeting_component, participatory_space: participatory_process) }
  let(:meeting) { create(:meeting, :published, :with_registrations_enabled, component:) }
  let(:meeting_tunned) { create(:meeting, :published, :with_registrations_enabled, component:) }

  def meeting_path(meeting)
    Decidim::EngineRouter.main_proxy(component).meeting_path(id: meeting.id)
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    allow(ENV).to receive(:fetch).and_return(nil)
    allow(ENV).to receive(:fetch).with("MEETING_REGISTRATION_PATH_#{meeting_tunned.id}").and_return("http://pokecode.net")
    visit meeting_path(meeting)
  end

  shared_examples "internal button" do
    it "has a normal follow button" do
      expect(page).to have_no_link("a[href='/link?external_url=http%3A%2F%2Fpokecode.net']")
      expect(page).to have_css(".follow-button")
    end
  end

  it_behaves_like "internal button"

  context "when a ENV var is present for the meeting" do
    before do
      visit meeting_path(meeting_tunned)
    end

    it "has a custom link" do
      expect(page).to have_link("a[href='/link?external_url=http%3A%2F%2Fpokecode.net']")
      expect(page).to have_css(".follow-button")
    end

    context "and registrations are not opened" do
      let(:meeting_tunned) { create(:meeting, :published, component:) }

      it_behaves_like "internal button"
    end
  end
end
