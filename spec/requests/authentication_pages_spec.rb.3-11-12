require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      #it { should have_selector('h1',    text: 'Sign in') }
      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.flash.error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.flash.error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: user.name) }
      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end


  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { Factory(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        #The code in Listing 9.10 introduces a second way, apart from Capybara’s visit method, to access a controller action: by issuing the appropriate HTTP request directly, in this case using the put method to issue a PUT request.
        #This issues a PUT request directly to /users/1, which gets routed to the update action of the Users controller (Table 7.1). This is necessary because there is no way for a browser to visit the update action directly—it can only get there indirectly by submitting the edit form—so Capybara can’t do it either. But visiting the edit page only tests the authorization for the edit action, not for update. As a result, the only way to test the proper authorization for the update action itself is to issue a direct request. (As you might guess, in addition to put Rails tests support get, post, and delete as well.)

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "as wrong user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { sign_in user }

        describe "visiting Users#edit page" do
          before { visit edit_user_path(wrong_user) }
          it { should have_selector('title', text: 'Home') }
        end

        describe "submitting a PUT request to the Users#update action" do
          before { put user_path(wrong_user) }
          specify { response.should redirect_to(root_path) }
        end
      end


      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
        end
      end

      describe "visiting user index" do
        before { visit users_path }
        it { should have_selector('title', text: 'Sign in') }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end

end
