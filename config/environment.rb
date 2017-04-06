require 'bundler'
Bundler.require
Dotenv.load

Dir[File.join(File.dirname(__FILE__), "../lib", "*.rb")].each {|f| require f}
