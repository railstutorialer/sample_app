require 'spec_helper'

describe "Micropost pages" do
  subject { page }
  let :user do
  	FactoryGirl.create :user
  end

  before do
  	sign_in user
  end

  describe 'micropost creation' do
  	before do
  		visit root_path
  	end

  	describe 'with invalid information' do
  		it 'should not create a micropost' do
  			result = expect do 
  				click_button 'Post' 
  			end
  			result.should_not change Micropost, :count
  		end

	  	describe 'error message' do
	  		before do
	  			click_button 'Post'
	  		end
	  		it { should have_content 'error' }
	  	end
  	end

  	describe 'with valid information' do
  		before do
  			fill_in 'micropost_content', with: 'Lorem ipsum'
  		end

  		it 'should create a micropost' do
  			result = expect do
  				click_button 'Post'
  			end
  			result.should (change Micropost, :count).by 1
  		end
  	end
  end

  describe 'micropost destruction' do
  	before {FactoryGirl.create :micropost, user: user }
  	describe 'as correct user' do
  		before {visit root_path }
  		it 'should delete a micropost' do
  			result =  expect do
  				click_link 'delete'
  			end
  			result.should (change Micropost, :count).by -1
  		end
  	end
  end
end
