#using the :user symbol causes factorygirl to simulate the User model
Factory.define :user do |user|
  user.name                   "John Sayeau"
  user.email                  "jsayeau@shaw.ca"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end