# MyinfoRuby

A ruby client :gem: to interact with MyInfo API :purple_heart:.

About MyInfo:

MyInfo - Designed by the Singapore Government, MyInfo is a service that enables citizens and residents to manage the use of their personal data for simpler online transactions. Users control and consent to the sharing of their data, and can view a record of past usage. MyInfo users will enjoy less form-filling and a reduced need for providing verifying documentation during online transactions.

MyInfo api integration : https://www.ndi-api.gov.sg/library/trusted-data/myinfo/introduction

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'myinfo_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install myinfo_ruby

## Usage
```ruby
config = {
  token_url: '',
  personal_url: '',
  code: '', # Code returned from authorise process.
  private_key: '', # Key generated while CSR for ssl purpose.
  client_id: '', # Client id provided by ndi-api.
  client_secret: '', # Client secret provided by ndi-api.
  attributes: '', # Attributes to be fetched from Api.
  redirect_url: '',# Redirect_url setup on ndi-api.
  auth_level: 'L2' #L2 if your using PKI signature, L0 if normal authorisation.
}
# Testing
key = File.read('./testing_private_key.pem')
config = {
  token_url: "https://test.api.myinfo.gov.sg/com/v3/token",
  personal_url: "https://test.api.myinfo.gov.sg/com/v3/person",
  code: '', # Code returned from authorise process.
  private_key: key,
  client_id: 'STG2-MYINFO-SELF-TEST',
  client_secret: '44d953c796cccebcec9bdc826852857ab412fbe2',
  attributes: 'name,aliasname,hanyupinyinname,hanyupinyinaliasname,dob',
  redirect_url: 'http://localhost:3001',
  auth_level: 'L2'
}

myinfo_client = MyinfoRuby::Client.new config
personal_data = myinfo_client.fetch_personal

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/myinfo_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MyinfoRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/myinfo_ruby/blob/master/CODE_OF_CONDUCT.md).
