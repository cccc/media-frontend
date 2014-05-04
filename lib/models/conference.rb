class Conference < ActiveRecord::Base
  has_many :events

  def recordings_url
    File.join 'http://cdn.media.ccc.de/', self.recordings_path
  end

  def logo_url
    if self.logo
      File.join 'http://static.media.ccc.de/media/', self.images_path, self.logo
    else
      "http://static.media.ccc.de/images/folder.png"
    end
  end

end
