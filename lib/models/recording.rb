class Recording < ActiveRecord::Base
  belongs_to :event

  HTML5 = %w[audio/ogg audio/mpeg audio/opus video/mp4 video/ogg video/webm vnd.voc/h264-lq vnd.voc/h264-hd]
  PREFERRED_VIDEO = %w[vnd.voc/h264-hd vnd.voc/h264-lg video/mp4 video/webm video/ogg]

  scope :downloaded, -> { where(state: 'downloaded') }
  scope :audio, -> { where(mime_type: %w[audio/ogg audio/mpeg audio/opus]) }
  scope :video, -> { where(mime_type: %w[video/mp4 vnd.voc/h264-lq vnd.voc/h264-hd video/ogg video/webm]) }

  def url
    File.join self.event.conference.recordings_url, self.folder || '', self.filename
  end

  def torrent_url
    url + '.torrent'
  end

  def display_mime_type
    case mime_type
    when 'vnd.voc/h264-lq'
      'video/mp4'
    when 'vnd.voc/h264-hd'
      'video/mp4'
    else
      mime_type
    end
  end

  def filetype
    case mime_type
    when 'vnd.voc/h264-lq'
      'MP4 (LQ)'
    when 'vnd.voc/h264-hd'
      'MP4 (HD)'
    when 'audio/mpeg'
      'MP3'
    else
      mime_type.split('/')[1]
    end
  end

end
