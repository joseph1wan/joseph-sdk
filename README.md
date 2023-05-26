# Lotr::Sdk

## Context

This project started as a take-home assignment for a company. I'm not using it to practice SDK development on the side.

## Overview

`lotr-sdk` is a Ruby gem that provides a SDK to help The Lord of the Rings lovers consume data about the epic books by J. R. R. Tolkien and the official movie adaptions by Peter Jackson. This SDK leverages [The One API](https://the-one-api.dev) the one API to rule them all.

This SDK currently implements methods to work with movies and movie quotes

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add lotr-sdk

## Usage

Get an access token by signing up for an account at [The One API](https://the-one-api.dev/sign-up).

```
# Provide API access token
# If you do not provide an access token, Lotr::Sdk looks for checks if you set `THE_ONE_ACCESS_TOKEN` environment variable.
client = Lotr::Sdk::Client.new(access_token: 'personal_access_token')

# Fetch all movies
movies = client.movies

# Fetch quotes belonging to a movie
client.movie_quotes_from_movie(movie.first)

# Note: The One API only provides quotes from these movies:
  - The Fellowship of the Ring (id: "5cd95395de30eff6ebccde5c")
  - The Two Towers (id: "5cd95395de30eff6ebccde5b")
  - The Return of the King (id: "5cd95395de30eff6ebccde5d")
  This version of the API will raise an error if you try to retrieve quotes from other movies. To disable this check, set the `DISABLE_MOVIE_CHECK` env variable to `1`

# Fetch all quotes
client.quotes
```

You can see the list of available methods with more details by generating and viewing the documentation:
```
bin/yard
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

Before running tests, set your access token to `THE_ONE_ACCESS_TOKEN` environment variable.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joseph1wan/joseph-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/joseph1wan/joseph-sdk/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Lotr::Sdk project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/joseph1wan/joseph-sdk/blob/main/CODE_OF_CONDUCT.md).
