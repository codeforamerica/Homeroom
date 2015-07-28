require 'rails_helper'
require 'capybara/rspec'

describe 'educator exports a student profile', :type => :feature do
  context 'educator with account exports student profile' do
    let!(:educator) { FactoryGirl.create(:educator_with_homeroom) }
    let!(:student) { FactoryGirl.create(:student_who_registered_in_2013_2014) }

    def educator_sign_in(educator)
      visit root_url
      click_link 'Sign In'
      fill_in 'educator_email', with: educator.email
      fill_in 'educator_password', with: educator.password
      click_button 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end

    before(:each) do
      educator_sign_in(educator)
      visit "/students/#{student.id}"
      click_on 'Export'
    end

    context 'to csv' do
      it 'sends a csv' do
        content_type = page.response_headers['Content-Type']
        expect(content_type).to eq 'text/csv'
      end
      it 'sets the right values' do
        csv = CSV.parse(page.body)
        expect(csv[0]).to eq ["Attendance"]
        expect(csv[1]).to eq ["School Year", "Absences", "Tardies"]
        expect(csv[2]).to eq ["2014-2015", "0", "0"]
      end
    end
  end
  context 'someone without account tries to export student profile' do
    let!(:student) { FactoryGirl.create(:student_who_registered_in_2013_2014) }
    it 'does not work' do
      visit "/students/#{student.id}.csv"
      expect(page).to have_content 'You need to sign in before continuing.'
    end
  end
end
