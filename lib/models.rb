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
