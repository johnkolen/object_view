#!/bin/bash

fgrep "object_view" Gemfile || cat ../object_view/ovtest.gemfile >> Gemfile

bundle add devise
bundle install

bin/rails g rspec:install
bin/rake object_view:install

bin/rails generate controller home index
cat - <<EOF >> app/views/home/index.html.erb
<p><%= current_user.inspect %></p>
<p><a href="<%= new_user_registration_path %>">Sign Up</a></p>
<p><a href="<%= new_user_session_path %>">Sign In</a></p>
EOF

sed -i -e 's/^end$/  root "home#index"\nend/' config/routes.rb
sleep 3

bin/rails g devise:install
bin/rails g devise user
bin/rails db:migrate
sed -i -e 's/devise_for :users/devise_for :users, path: "auth"/' config/routes.rb

bin/rails generate model person name:string age:integer
bin/rails db:migrate
#bin/rails generate object_view:scaffold person
