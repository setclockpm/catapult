

#Bugcrowd Assessment Episode I

### JSON API Format
I used this gem to ensure JSON API format
https://github.com/rails-api/active_model_serializers/tree/0-10-stable

```ruby
gem 'active_model_serializers', '~> 0.10.0'
```

```ruby
ActiveModel::Serializer.config.adapter = :json_api
ActiveModelSerializers.config.key_transform = :underscore
```

###Comments
This took me  longer than 2 hours.

###Reasoning
There are some comments strewn around explaining why I opted for a certain method or callback or I felt I may have done something different.

###  used rspec to test project
```ruby
gem 'rspec-rails', '~> 3.5'
```
