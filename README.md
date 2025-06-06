# ObjectView
ObjectView is a Rails gem for simplifying creation of models, forms, and displays.

## Usage
ObjectView lets you define models and the construct a collection of forms and displays incorporating
them.

Here's how to create a simple person model and generate an interface for it.
```base
$ bin/rails generate model person name:string age:integer
$ bin/rails db:migrate
$ bin/rails generate object_view:scaffold person
```

The object_view:scaffold generate looks at the model and is aware of attributes and associations
while it constructs a controller, views, and tests.

## Installation
Here's the workflow for a new project using ObjectView as of Rails 8.

```bash
$ rails new myapp -c bootstrap
$ cd myapp
```

Add these lines to your application's Gemfile:

```ruby
gem "object_view", path: "../object_view"

group :development, :test do
  gem "faker", "~> 3.5"
  gem "database_cleaner-active_record", "~> 2.2.1"
  gem "rspec-rails", "~> 8.0.0"
  gem "factory_bot_rails", "~> 6.4"
  gem "rails-controller-testing", "~>1.0.5"
end
```

And then execute:
```bash
$ bundle install
$ bin/rails generate rspec:install
$ bin/rake object_view:install
```
### Adding model support

```bash
bin/rails generate model dog name:string age:integer
bin/rails db:migrate
bin/rails generate object_view:scaffold dog
# edit spec/factories/dogs.rb to make sure values are reasonable for the model
rspec spec/models/dogs.rb
# edit app/views/_form.html.erb, app/views/_dog.html.erb, and  app/views/_table_row.html.erb to make sure field directives are correct
rspec spec/views/dogs
# edit app/controllers/dogs_controller.rb to make sure dog_params are reasonable for the model
# edit spec/requests/dogs_spec.b to add attributes
rspec spec/requests/dogs_spec.b
```
## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
