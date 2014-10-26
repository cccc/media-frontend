class Conference < ActiveRecord::Base
  has_many :events

  def recordings_url
    File.join Settings.cdnURL, self.recordings_path
  end

  def logo_url
    if self.logo
      File.join '/images/logos', self.images_path, File.basename(self.logo, File.extname(self.logo))+'.png'
    else
      File.join '/images/logos/unknown.png'
    end
  end

end
