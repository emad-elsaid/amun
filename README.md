# Amun (Work in progress)

## "King of the gods and god of the wind"
[![Gem Version](https://badge.fury.io/rb/amun.svg)](http://badge.fury.io/rb/amun)
[![Build Status](https://travis-ci.org/blazeeboy/amun.svg?branch=master)](https://travis-ci.org/blazeeboy/amun)
[![Code Climate](https://codeclimate.com/github/blazeeboy/amun/badges/gpa.svg)](https://codeclimate.com/github/blazeeboy/amun)
[![Test Coverage](https://codeclimate.com/github/blazeeboy/amun/badges/coverage.svg)](https://codeclimate.com/github/blazeeboy/amun)

A minimal CLI text editor, built on Ruby, looking for Emacs as it's father and idol.

As developing packages for Emacs with Elisp wasn't always a fun or easy task, Starting a project that leverage ruby ability for fast development will be a good move towards
an open, easy to extend editor.

When I started this project I had 2 options, taking the VIM way or emacs way, looking in the current state of the two editors, It's obvious that emacs approach has a better
extensibility over VIM, emacs customizability is far superior to VIM, so building this project as a minimal and emacs-like would open the door for vim users to have their own
bindings as a package like emacs Evil mode, but doing the other way around won't help emacs users.

## Advantages of building an editor in ruby

* We can use ruby gems as package management
* we already have bundler to fix dependencies, upgrade, downgrade gems (plugins in this case), you can even add sources for gems or get a gem from github or company inhouse gems.
* you can reflect on the runtime and autocomplete commands
* plugins can mutate all parts of the runtime application classes/objects included
* ruby is easy to learn so it'll be easier to build gems that is specifically for this editor
* lots of gems already exists and could be loaded into the editor environment
* you can use it locally or remotly as it's terminal based
* documentation included, rdoc is already there to be used

## Installation

    $ gem install amun

## Usage

amun install an executable to your path, so executing `amun` from your command-line should launch amun

## Structure


### Helpers

Helpers are modules that any class can use to do side tasks, think of it like Ruby on rails helpers.

* Only modules no classes
* doesn't depend on each other
* depends on the project dependencies only like "Curses"

### MajorModes

Classes that are responsible the following for a buffer object:

* event handling
* manipulating IO
* Rendering IO into a curses window


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/blazeeboy/amun.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
