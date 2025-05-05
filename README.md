# README

## Features

* WeatherService service object that can fetch the forecast
* Immutable [Data](https://docs.ruby-lang.org/en/master/Data.html) definitions for API responses
* Autocomplete location lookup
* Displays a given location's current temperature, high, low, and SVG icon for most weather conditions
* If location has clear conditions and is nighttime at location, will display a moon
* Shows seven-day forecast conditions with highs/lows
* Unit tests that utilize VCR to cache third-party API responses
* Caching both geocoding and weather requests
* We don't need to know the user's or the location's timezone
* Doesn't require any API keys

## Future work

Things I would want to do if I were to continue working on this:

* The debounce on the autocomplete component seems too low. New requests are being sent before prior ones can complete,
  leading to some delayed UI updates.
* Expand test suite coverage
* Setup solid_cache for development. This will ensure cached results persist across server runs
* Setup [Steep](https://github.com/soutaro/steep) to perform type checking
* Further flesh out [RBS](https://github.com/ruby/rbs) type definitions
* Internationalization (date formatting, temperature units)
* Hourly forecasts and charting temperature values over time
* Make clicking on a future day display more information
* If performance is critical, both [Nominatim](https://nominatim.org/release-docs/develop/api/Overview/)
  and [Open-meteo](https://open-meteo.com) can be self hosted

## Setup

### Dev Containers (Recommended)

* Install
  Docker ([Docker](https://docs.docker.com/get-started/get-docker/), [Podman](https://podman-desktop.io/), [Orbstack](https://orbstack.dev/))
* Install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  extension if using VS Code
* Open project directory and "Re-open in dev container" when prompted

### Locally

* Make sure you have Ruby and Postgres installed. I prefer [rbenv](https://github.com/rbenv/rbenv)
  and [Postgres.app](https://postgresapp.com)
  respectively.
* Run `./bin/setup`

## Commands

* `./bin/rails s`: start the rails server
* `./bin/setup`: Creates development and test databases and starts the development server
* `./bin/rails test`: Run test suite