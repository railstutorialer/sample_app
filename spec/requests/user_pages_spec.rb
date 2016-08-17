require 'spec_helper'

describe "User pages" do

	subject {page}
	describe "signup page" do
		before { visit signup_path }

		it { should have_selector 'h1', text: 'Sign up'}

		it {should have_selector 'title', text: (full_title 'Sign up')}
	end

	describe 'profile page' do
		let :user do
			FactoryGirl.create :user
		end
		before { visit user_path user }

		it { should have_selector 'h1', text: user.name }
		it { should have_selector 'title', text: user.name }
	end

	describe 'signup' do
		before do
			visit signup_path
		end

		let(:submit) { 'Create my account' }

		describe 'with invalid information' do
			it 'should not create a user' do
				result = expect do
					click_button submit
				end

				result.not_to change User, :count
			end

			describe "after submission" do
				before do 
					click_button submit 
				end

				it { should have_selector 'title', text: 'Sign up' }
				it { should have_content 'error' }
			end
		end

		describe 'with valid information' do
			before do
				fill_in 'Name', with: 'Example User'
				fill_in 'Email', with: 'user@example.com'
				fill_in 'Password', with: 'foobar'
				fill_in 'Confirmation', with: 'foobar'
			end

			it 'should create a user' do
				result = expect do
					click_button submit
				end
				result.to (change User, :count).by 1
			end

			describe 'after saving the user' do
				before do
					click_button submit
				end

				let :user do
					User.find_by_email 'user@example.com'
				end

				it { should have_selector 'title' , text: user.name }
				it { should have_selector 'div.alert.alert-success', text: 'Welcome' }
				it { should have_link 'Sign out' }
			end
		end
	end

end
