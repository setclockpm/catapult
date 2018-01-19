

#Scout RFP Technical interview Setup

### Download and install Postman
  > A powerful GUI platform to make your API development faster & easier, from building API requests through testing, documentation and sharing.

[OSX Download](https://app.getpostman.com/app/download/osx64)

Spend 5-10 minutes understanding postman basics if needed on [Postman "How To" Playlist](https://www.youtube.com/playlist?list=PLM-7VG-sgbtCJYpjQfmLCcJZ6Yd74oytQ)


### Setup rvm or rbenv ( rvm preferred )
https://rvm.io/rvm/install
```sh
rvm get stable
```

### Ensure sqlite3, ruby, separate gemset and rails 5.x
```sh
sqlite3 --version

rvm install 2.4
rvm use 2.4@api-breed --create
gem install rails  # 5.2
```
### Ensure at least high level understanding of JSON API Spec format
This is nothing crazy, just a format specification that is widely used in our daily development.
http://jsonapi.org/format/


### Build JSON APIs with ease
We are using this gem to ensure JSON API format
https://github.com/rails-api/active_model_serializers/tree/0-10-stable

```ruby
gem 'active_model_serializers', '~> 0.10.0'
```

```ruby
ActiveModel::Serializer.config.adapter = :json_api
ActiveModelSerializers.config.key_transform = :underscore
```


### Create empty api rails app
```sh
rails new todo_api_app --api
```

### Please use rspec to test project
```ruby
gem 'rspec-rails', '~> 3.5'
```
```sh
rails generate rspec:install
```
[json_spec](https://github.com/collectiveidea/json_spec) is a really nice gem to ease API testing.

Some examples for [rspec requests specs](https://relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec)
