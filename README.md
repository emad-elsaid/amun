# Amun (Work in progress) ![Build Status](https://travis-ci.org/blazeeboy/amun.svg) ![Gem version](https://badge.fury.io/rb/amun.svg)

A minimal CLI text editor, built on Ruby, looking for Emacs as it's father and idol.

As developing packages for Emacs with Elisp wasn't always a fun or easy task, Starting a project that leverage ruby ability for fast development will be a good move towards
an open, easy to extend editor.

When I started this project I had 2 options, taking the VIM way or emacs way, looking in the current state of the two editors, It's obvious that emacs approach has a better
extensibility over VIM, emacs customizability is far superior to VIM, so building this project as a minimal and emacs-like would open the door for vim users to have their own
bindings as a package like emacs Evil mode, but doing the other way around won't help emacs users.

## Installation

    $ gem install amun

## Usage

amun install an executable to your path, so executing `amun` from your command-line should launch amun

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/blazeeboy/amun.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
