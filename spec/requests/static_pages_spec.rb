require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    before do 
      visit root_path
    end

    subject { page }

    it {should have_selector 'h1', text: 'Sample App'}

    it { should have_selector 'title', text: (full_title '')}

    it { should_not have_selector 'title', text: (full_title 'Home') }
  end

  describe "Help page" do
    before do
      visit help_path
    end

    subject {page}

    it { should have_selector 'h1', text: 'Help'}

    it { should have_selector 'title', text: (full_title 'Help') }
  end

  describe "About page" do
    before do
      visit about_path
    end

    subject {page}

    it { page.should have_selector 'h1', text: 'About Us' }

    it { page.should have_selector 'title', text: (full_title 'About Us')}

  end

  describe "Contact page" do
    before do
      visit contact_path
    end

    subject {page}

    it { page.should have_selector 'h1', text: 'Contact' }

    it { page.should have_selector 'title', text: (full_title 'Contact') }

  end
end