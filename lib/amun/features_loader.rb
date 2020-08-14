module Amun
  # load all files in the features directory
  module FeaturesLoader
    def self.call
      path = File.expand_path('../features', __FILE__)
      features = Dir.glob(File.join(path, '**/*'))
      features.each do |feature|
        require feature
      end
    end
  end
end
