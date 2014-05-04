# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require 'ostruct'
require 'json'
Settings = OpenStruct.new JSON.load(File.open('settings.json')) unless defined? Settings
