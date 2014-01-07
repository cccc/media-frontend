class Conference < ActiveRecord::Base
  has_many :events
end

class Event < ActiveRecord::Base
  belongs_to :conference
  has_many :recordings
end

class Recording < ActiveRecord::Base
  belongs_to :event
end

class Folder
  def initialize(location:nil)
    @location = location
  end
  attr_accessor :location, :conference

  def name
    File.basename @location
  end
end
