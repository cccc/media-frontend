class Folder
  def initialize(location:nil)
    @location = location
  end
  attr_accessor :location, :conference

  def name
    File.basename @location
  end
end
