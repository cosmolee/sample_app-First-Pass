def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end


def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end


def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"

  # Sign in when not using Capybara as well.
  # listing 9.12
  # "This is necessary when using one of the HTTP request methods directly (get, post, put, or delete), as we’ll see in Listing 9.47." 
  # "Note that the test cookies object isn’t a perfect simulation of the real cookies object; in particular, the cookies.permanent method seen in Listing 8.19 doesn’t work inside tests.)"
  # And this seems to be why Hartl isn't using it in the book, because cookies.signed breaks the rspec tests.  Accordingly, I've changed the sessions_helper.rb code back to the original, to NOT use "signed".  Then the tests pass....   Grrrr....
  # cookies.signed[:remember_token] = user.remember_token
  cookies[:remember_token] = user.remember_token

end



RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.flash.error', text: message)
  end
end


