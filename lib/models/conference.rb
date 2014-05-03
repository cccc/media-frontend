class Conference < ActiveRecord::Base
  has_many :events

  def recordings_url
    File.join 'http://cdn.media.ccc.de/', self.recordings_path
  end

  # TODO move logos into /media folder
  def logo_url
    "http://static.media.ccc.de/#{self.logo}"
  end

end
