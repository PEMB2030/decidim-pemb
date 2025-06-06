# frozen_string_literal: true

require "rails_helper"

describe "Visit_the_conferences_page", perform_enqueued: true do
  let(:organization) { create :organization }
  let!(:conference) { create :conference, organization: }
  let!(:conference_speaker) { create :conference_speaker, :published, conference:, position: { ca: "Un altre rol", en: "Another role" } }
  let!(:conference_moderator) { create :conference_speaker, :published, conference:, position: { ca: "Moderadora", en: "Moderator" } }

  before do
    switch_to_host(organization.host)
    visit decidim_conferences.conference_conference_speakers_path(conference, locale: "ca")
  end

  it "separates speakers and moderators" do
    within "#conference_speakers-grid > .row:first-child" do
      expect(page).to have_content("Ponents")

      within ".conference__speaker__item-text" do
        expect(page).to have_content(translated(conference_speaker.position))
        expect(page).to have_no_content("Moderadora")
      end
    end

    within "#conference_speakers-grid > .row:last-child" do
      expect(page).to have_content("Moderadores")

      within ".conference__speaker__item-text" do
        expect(page).to have_no_content(translated(conference_speaker.position))
        expect(page).to have_content("Moderadora")
      end
    end
  end
end
