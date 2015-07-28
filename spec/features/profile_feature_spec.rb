require 'rails_helper'
require 'capybara/rspec'

describe 'educator views student profile', :type => :feature do
  context 'educator with account views student profile' do
    let!(:educator) { FactoryGirl.create(:educator_with_homeroom) }

    before(:each) do
      educator_sign_in(educator)
      visit "/students/#{student.id}"
    end

    context 'student has no discipline incidents' do
      let!(:student) { FactoryGirl.create(:student_who_registered_in_2013_2014) }
      it 'shows no discipline incidents' do
        expect(page).to have_content 'No behavior incidents'
      end
    end
    context 'student has discipline incidents' do
      let!(:student) { FactoryGirl.create(:student_with_discipline_incident) }
      it 'shows the discipline incident' do
        expect(page).not_to have_content 'No behavior incidents'
      end
    end
    context 'student has no attendance events' do
      let!(:student) { FactoryGirl.create(:student_who_registered_in_2013_2014) }
      it 'shows no attendance events' do
        expect(page).to have_content 'No absences or tardies'
      end
    end
    context 'student has discipline incidents' do
      let!(:student) { FactoryGirl.create(:student_with_attendance_event) }
      it 'shows the discipline incident' do
        expect(page).not_to have_content 'No absences or tardies'
      end
    end
    context 'student has no MCAS results' do
      let!(:student) { FactoryGirl.create(:student_who_registered_in_2013_2014) }
      it 'shows no MCAS results' do
        expect(page).not_to have_css '.mcas-result-section'
      end
    end
    context 'student has MCAS results' do
      let!(:student) { FactoryGirl.create(:student_with_mcas_result) }
      it 'shows MCAS results' do
        expect(page).to have_css '.mcas-result-section'
      end
    end
    context 'student has no STAR results' do
      let!(:student) { FactoryGirl.create(:student_who_registered_in_2013_2014) }
      it 'shows no STAR results' do
        expect(page).not_to have_css '.star-result-section'
      end
    end
    context 'student has STAR results' do
      let!(:student) { FactoryGirl.create(:student_ahead_in_reading) }
      it 'shows STAR result' do
        expect(page).to have_css '.star-result-section'
      end
    end
  end
end
