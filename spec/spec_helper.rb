require 'curses'
require 'rspec/its'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

ARGV.clear # ARGV is used in a feature to load files
paths_to_load = ['../shared_examples/**/*.rb', '../../lib/**/*.rb']
paths_to_load.each do |path|
  Dir.glob(File.expand_path(path, __FILE__)).each do |file|
    next if file.match?(/features/)
    require file
  end
end

RSpec.configure do |c|
  c.before(:example) do
    allow(Curses).to receive(:init_pairs)

    window = instance_double('Curses::Window')
    class_double('Curses', stdscr: window).as_stubbed_const(transfer_nested_constants: true)
    class_double('Curses::Window').as_stubbed_const(transfer_nested_constants: true)

    allow(window).to receive(:subwin).and_return(window)
  end
end
