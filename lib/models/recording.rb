class Recording < ActiveRecord::Base
  belongs_to :event

  scope :downloaded, -> { where(state: 'downloaded') }

  def url
    self.folder ||= ""
    File.join self.event.conference.recordings_url, self.folder, self.filename
  end

end
