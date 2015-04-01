# bunnyship
Distributed multiplayer Battleship game using RabbitMQ

## Install

Install Ruby 2.1.1.

```bash
  rbenv install 2.1.1
```

Install bundler.

```bash
  gem install bundler
```

Install the bundle.

```bash
  bundle install
```

## Run it

```bash
  ruby test/run.rb
```

To target yourself you have to specify your player name, which is sketchmeister.

Comment out the console_display.run line if you just want to write to the html file.


## Running Tests

Run all tests:

```bash
  bundle exec rake test
```
