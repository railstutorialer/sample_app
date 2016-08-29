require 'spec_helper'

describe "Authentication" do

	subject {page}

	describe "signin page" do
		before do
			visit signin_path
		end

		it { should have_selector 'h1', text: 'Sign in' }
		it { should have_selector 'title', text: 'Sign in' }
	end

	describe 'not signed in' do

		before do
			visit root_path
		end

		it { should_not have_link 'Profile' }
		it { should_not have_link 'Settings' }
	end

	describe 'signin' do
		before do
			visit signin_path
		end

		describe 'with invalid information' do
			before do
				click_button 'Sign in'
			end

			it { should have_selector 'title', text: 'Sign in' }
			it { should have_error_message 'Invalid' }

			describe 'after visiting another page' do
				before do 
					click_link 'Home' 
				end
				it { should_not have_selector 'div.alert.alert-error' }
			end
		end

		describe 'with valid information' do
			let :user do
				FactoryGirl.create :user
			end

			before do
				sign_in user
			end

			it { should have_selector 'title', text: user.name }
			it { should have_link 'Users', href: users_path }
			it { should have_link 'Profile', href: (user_path user) }
			it { should have_link 'Settings', href: (edit_user_path user) }
			it { should have_link 'Sign out', href: signout_path }
			it { should_not have_link 'Sign in', href: signin_path }

			describe 'followed by signout' do
				before do
					click_link 'Sign out'
				end

				it { should have_link 'Sign in'}
			end
		end
	end

	describe 'authorization' do
		describe 'for non-signed-in users' do
			let :user do
				FactoryGirl.create :user
			end

			describe 'in the Users controller' do

				describe 'visiting the following page' do
					before do
						visit following_user_path user
					end

					it { should have_selector 'title', text: 'Sign in'}
				end

				describe 'visiting the followers page' do
					before do 
						visit followers_user_path user
					end

					it { should have_selector 'title', text: 'Sign in' }
				end

				describe 'visiting the edit page' do
					before do
						visit (edit_user_path user)
					end

					it { should have_selector 'title', text: 'Sign in' }
				end

				describe 'submitting to the update action' do
					before { put (user_path user)}
					specify { response.should redirect_to signin_path}
				end
			end

			describe 'in the Microposts controller' do
				describe 'submitting to the create action' do
					before do
						post microposts_path
					end

					specify { response.should redirect_to signin_path }
				end

				describe 'submitting to the destroy action' do
					before do
						micropost = FactoryGirl.create :micropost
						delete (micropost_path micropost)
					end
					specify { response.should redirect_to signin_path }
				end
			end

			describe 'in the Relationships controller' do
				describe 'submitting to the create action' do
					before do 
						post relationships_path 
					end
					
					specify { response.should redirect_to signin_path}
				end

				describe 'submitting to the destory action' do
					before do
						delete relationship_path 1
					end

					specify { response.should redirect_to signin_path }
				end

			end
		end

		describe 'as wrong user' do
			let :user do
				FactoryGirl.create :user
			end

			let :wrong_user do
				FactoryGirl.create :user, email: 'wrong@example.com'
			end

			before do
				sign_in user
			end

			describe 'visiting Users#edit page' do
				before { visit edit_user_path wrong_user }
				it { should_not have_selector 'title', text: (full_title 'Edit user') }
			end

			describe 'submitting a PUT request to the Users#update action' do
				before {put (user_path wrong_user)}
				specify { response.should redirect_to root_path }
			end
		end

		describe 'for non signed-in users' do
			let :user do
				FactoryGirl.create :user
			end

			describe 'when attempting to visit a protected page' do
				before do
					visit edit_user_path user
					fill_in 'Email', with: user.email
					fill_in 'Password', with: user.password
					click_button 'Sign in'
				end

				describe 'after signing in' do
					it 'should render the desired protected page' do
						page.should have_selector 'title', text: 'Edit user'
					end
				end

				describe 'when signing in again' do
					before do
						visit signin_path
						fill_in 'Email', with: user.email
						fill_in 'Password', with: user.password
						click_button 'Sign in'
					end

					it 'should render the default (profile) page' do
						page.should have_selector 'title', text: user.name
					end
				end
			end

			describe 'visiting the user index' do
				before do
					visit users_path
				end
				it { should have_selector 'title', text: 'Sign in' }
			end
		end

		describe 'as non-admin user' do
			let :user do
				FactoryGirl.create :user
			end

			let :non_admin do
				FactoryGirl.create :user
			end

			before do
				sign_in non_admin
			end

			describe 'submitting a DELETE request to the Users#destroy action' do
				before do 
					delete user_path user 
				end

				specify do
					response.should redirect_to root_path 
				end
			end
		end
	end
end