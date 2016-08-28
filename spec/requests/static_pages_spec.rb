require 'spec_helper'
describe "Static pages" do
  subject { page }
  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end
  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }
    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }

    it 'should have the right links on the layout' do 
      click_link 'About'
      page.should have_selector 'title', text: (full_title 'About Us')

      click_link 'Help'
      page.should have_selector 'title', text: (full_title 'Help')

      click_link 'Contact'
      page.should have_selector 'title', text: (full_title 'Contact')

      click_link 'Home'
      click_link 'Sign up now!'
      page.should have_selector 'title', text: (full_title 'Sign up')

      click_link 'sample app'
      page.should have_selector 'title', text: (full_title '')
    end

    describe 'for signed in users' do
      let :user do
        FactoryGirl.create :user
      end

      describe 'with 0 microposts' do
        before do
          sign_in user
          visit root_path
        end

        it { should have_content '0 microposts'}

      end

      describe 'with 1 micropost' do
        before do 
           FactoryGirl.create :micropost, user: user, content: 'Lorem ipsum'
           sign_in user
           visit root_path
        end
        it {should have_content '1 micropost' }
      end

      describe 'with 2 microposts' do
        before do
          FactoryGirl.create :micropost, user: user, content: 'Lorem ipsum'
          FactoryGirl.create :micropost, user: user, content: 'Dolor sit amet'
          sign_in user
          visit root_path
        end

        it { should have_content '2 microposts'}


        it "should render the user's feed" do
          user.feed.each do |item|
            page.should have_selector "li##{item.id}", text: item.content
          end
        end
      end
    end
  end
  describe "Help page" do
    before do
      visit help_path
    end
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
  end
  describe "About page" do
    before do
      visit about_page
    end
    let(:heading) {'About Us'}
    let(:page_title) { 'About' }
  end
  describe "Contact page" do
    before do
      visit contact_page
    end
    let(:heading) {'Contact'}
    let(:page_title) {'Contact'}
  end

end