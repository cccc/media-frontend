class Conference < ActiveRecord::Base
  has_many :events

  def recordings_url
    File.join Settings.cdnURL, self.recordings_path
  end

  def logo_url
    if self.logo
      File.join Settings.staticURL, self.images_path, self.logo
    else
      "#{Settings.staticURL}/images/folder.png"
    end
  end

end
