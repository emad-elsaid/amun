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
    window = instance_double('Curses::Window')
    class_double('Curses', stdscr: window).as_stubbed_const(transfer_nested_constants: true)
    class_double('Curses::Window').as_stubbed_const(transfer_nested_constants: true)

    {
      color_pairs: 256 * 256,
      init_pair: true,
      color_pair: true,
      init_screen: true,
      curs_set: true,
      raw: true,
      noecho: true,
      start_color: true,
      'ESCDELAY=' => true
    }.each do |method, return_value|
      allow(Curses).to receive(method).and_return(return_value)
    end

    {
      subwin: window,
      maxx: 100,
      maxy: 100,
      erase: true,
      scrollok: true,
      attron: true,
      attroff: true,
      refresh: true,
      resize: true,
      move: true,
      '<<' => true,
      'keypad=' => true,
      'timeout=' => true
    }.each do |method, return_value|
      allow(window).to receive(method).and_return(return_value)
    end
  end
end
