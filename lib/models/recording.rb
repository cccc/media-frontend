class Recording < ActiveRecord::Base
  belongs_to :event

  HTML5 = ['audio/ogg', 'audio/mpeg', 'video/mp4', 'video/ogg', 'video/webm']

  scope :downloaded, -> { where(state: ['downloaded', 'released']) }
  scope :audio, -> { where(mime_type: ['audio/ogg', 'audio/mpeg']) }
  scope :video, -> { where(mime_type: ['video/mp4', 'video/ogg', 'video/webm']) }

  def url
    self.folder ||= ""
    File.join self.event.conference.recordings_url, self.folder, self.filename
  end

  def torrent_url
    url + '.torrent'
  end

end
