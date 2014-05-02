class Conference < ActiveRecord::Base
  has_many :events

  def recordings_url
    File.join 'http://cdn.media.ccc.de/', self.recordings_path
  end

end
