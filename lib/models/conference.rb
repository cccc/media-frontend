class Conference < ActiveRecord::Base
  has_many :events

  def get_recordings_path
    File.join 'http://cdn.media.ccc.de/', self.recordings_path
  end

end
