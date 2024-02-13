> [!WARNING]
> Please note that this client is under active development and is not yet ready for production use.  We encourage you to try out its features and provide feedback, and if you're comfortable contributing to an in-progress project, we welcome your help in improving it. However, we recommend against deploying it to a production environment until its features have been more thoroughly tested and stabilized. We appreciate your understanding and patience!

# Swiftner API Ruby Client

This is a Ruby client for interacting with the Swiftner API. It allows you to work with videos, transcriptions, errors, and perform various actions such as uploading, deleting, updating, and fetching information. This client make it easier to deal with HTTP requests by providing a Ruby-oriented interface with built-in error handling.

## Requirements

- Ruby version: 3.0.0 or later

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add swiftner

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install swiftner

## Usage

This section includes syntax examples of some of the key features of the Swiftner API Ruby client.

### Initializing the Client
```ruby
@api_key = "swiftner_api_key"
@client = Swiftner::Client.new(@api_key)
```

### Working with Video Content
```ruby
@video_content_service = Swiftner::API::VideoContent

# Find video contents
video_contents = @video_content_service.find_video_contents

# Find specific video content by ID
video_content = @video_content_service.find(1)

# Update the title of a video content
video_content.update(title: "New title")
```

### Working with Uploads
```ruby
@upload_service = Swiftner::API::Upload

# Find uploads
uploads = @upload_service.find_uploads

# Create an upload
upload = @upload_service.create(sample_attributes)

# Delete an upload
upload.delete

# Transcribe an upload
upload.transcribe("no")
```

### Handling Exceptions
The Swiftner API Ruby Client includes custom exceptions for handling API errors. These inherit from either the base Swiftner::Error class or the standard Ruby StandardError class.
```ruby
begin
  # some code that might raise an exception
rescue Swiftner::Forbidden => e
  puts "Handle forbidden error here"
rescue Swiftner::Unauthorized => e
  puts "Handle unauthorized error here"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mrtnin/swiftner. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mrtnin/swiftner/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Swiftner project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mrtnin/swiftner/blob/main/CODE_OF_CONDUCT.md).
