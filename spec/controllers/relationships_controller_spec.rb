require 'spec_helper'

describe RelationshipsController do
	let :user do
		FactoryGirl.create :user
	end

	let :other_user do
		FactoryGirl.create :user
	end
	
	before do
		sign_in user
	end

	describe 'creating a relationship with Ajax' do
		it 'should increment the Relationship count' do
			result = expect do
				xhr :post, :create, relationship: {followed_id: other_user.id }
			end
			result.should (change Relationship, :count).by 1
		end

		it 'should respond with success' do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			response.should be_success
		end
	end

	describe 'destroying a relationship with Ajax' do
		before do
			user.follow! other_user
		end
		let :relationship do
			user.relationships.find_by_followed_id other_user
		end

		it 'should decrement the Relationship count' do
			result = expect do
				xhr :delete, :destroy, id: relationship.id
			end
			result.should (change Relationship, :count).by -1
		end

		it 'should respond with success' do
			xhr :delete, :destroy, id: relationship.id
			response.should be_success
		end
	end

end