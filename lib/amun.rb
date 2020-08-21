require 'curses'

path = File.expand_path('amun', __dir__)
files = Dir.glob(File.join(path, '**/*.rb'))
files.each { |file| require file }

# King of the gods and god of the wind
module Amun
end
