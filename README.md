# Anonymise
Anonymise your postgres database
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'anonymise'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install anonymise
Create `anonymise.yml` file in your local machine

```$xslt

{
  users: {email: 'email',last_name: 'string'},
}

```
`users` is a table  in the database you want to anonymise

`email: 'email'` defines a column in users that has data type email

`last_name: 'string''` defines a column is users table that has data type string

Datatypes that can be used:-
```aidl
1. email
2. string
3. number
4. mobile
5. url
```
## Usage
```$xslt
   $ anonymise fake db:dbname path:path_to_anonymise.yml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thirunjuguna/anonymise. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Anonymise project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/thirunjuguna/anonymise/blob/master/CODE_OF_CONDUCT.md).
