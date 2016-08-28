include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector 'div.alert.alert-error', text: message
	end
end

RSpec::Matchers.define :have_success_message do |message|
	match do |page|
		page.should have_selector 'div.alert.alert-success', text: message
	end
end

RSpec::Matchers.define :have_pagination do
	match do |page|
		page.should have_selector '.pagination'
	end
end

def sign_in user
	visit signin_path
	fill_in 'Email', with: user.email
	fill_in 'Password', with: user.password
	click_button 'Sign in'
	cookies[:remember_token] = user.remember_token
end

def valid_signup 
	fill_in 'Name', with: 'Example User'
	fill_in 'Email', with: 'user@example.com'
	fill_in 'Password', with: 'foobar'
	fill_in 'Confirm Password', with: 'foobar'

	click_button submit
end