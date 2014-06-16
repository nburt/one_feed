def create_user(attributes = {})
  user = new_user(attributes)
  user.save!
  user
end

def new_user(attributes= {})
  defaults = {
    first_name: 'Nate',
    last_name: 'Burt',
    email: 'nate@example.com',
    password: 'password'
  }
  User.new(defaults.merge(attributes))
end

def login_user(user)
  visit '/'
  within 'header' do
    fill_in 'user[email]', :with => "#{user.email}"
    fill_in 'user[password]', :with => "#{user.password}"
    click_button 'Sign In'
  end
end