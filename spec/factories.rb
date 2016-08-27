FactoryGirl.define do
	factory :user do
		sequence :name do |n|
			"Person #{n}"
		end
		sequence :email do |n|
			"person_#{n}@example.com"
		end
		password "foobar"
		password_confirmation "foobar"
		factory :admin do
			admin true
		end
	end

	factory :micropost do
		content 'Lorem ipsum'
		user
	end
end