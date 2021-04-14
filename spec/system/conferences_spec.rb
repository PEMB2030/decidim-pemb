# frozen_string_literal: true

require "rails_helper"
require "byebug"

describe "Visit the conferences page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let!(:conference) { create :conference, organization: organization }
  let!(:conference_speaker) { create :conference_speaker, conference: conference }
  let!(:conference_moderator) { create :conference_speaker, conference: conference, position: { ca: "Moderadora", en: "Moderator" } }

  before do
    switch_to_host(organization.host)
    visit decidim_conferences.conference_conference_speakers_path(conference, locale: "ca")
  end

  it "separates speakers and moderators" do
    within "#conference_speakers-grid > .row:first-child" do
      expect(page).to have_content("PONENTS")

      within ".data-role" do
        expect(page).to have_content(translated(conference_speaker.position))
        expect(page).not_to have_content("Moderadora")
      end
    end

    within "#conference_speakers-grid > .row:last-child" do
      expect(page).to have_content("MODERADORES")

      within ".data-role" do
        expect(page).not_to have_content(translated(conference_speaker.position))
        expect(page).to have_content("Moderadora")
      end
    end
  end
end
