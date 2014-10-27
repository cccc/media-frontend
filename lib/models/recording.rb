class Recording < ActiveRecord::Base
  belongs_to :event

  HTML5 = ['audio/ogg', 'audio/mpeg', 'video/mp4', 'video/ogg', 'video/webm']

  scope :downloaded, -> { where(state: 'downloaded') }
  scope :audio, -> { where(mime_type: ['audio/ogg', 'audio/mpeg']) }
  scope :video, -> { where(mime_type: ['video/mp4', 'vnd.voc/h264-lq', 'vnd.voc/h264-hd', 'video/ogg', 'video/webm']) }

  def url
    File.join self.event.conference.recordings_url, self.folder || '', self.filename
  end

  def torrent_url
    url + '.torrent'
  end

  def filetype
    case mime_type
    when 'vnd.voc/h264-lq'
      'MP4 (LQ)'
    when 'vnd.voc/h264-hd'
      'MP4 (HD)'
    else
      mime_type.split('/')[1]
    end
  end

end
