class Recording < ActiveRecord::Base
  belongs_to :event

  HTML5 = %w[audio/ogg audio/mpeg audio/opus video/mp4 video/ogg video/webm vnd.voc/h264-lq vnd.voc/h264-sd vnd.voc/webm-hd vnd.voc/h264-hd]
  PREFERRED_VIDEO = %w[vnd.voc/h264-hd vnd.voc/h264-lq video/mp4 vnd.voc/h264-sd vnd.voc/webm-hd video/webm video/ogg]

  scope :downloaded, -> { where(state: 'downloaded') }
  scope :by_mime_type, ->(mime_type) { where(mime_type: mime_type) }
  scope :audio, -> { where(mime_type: %w[audio/ogg audio/mpeg audio/opus]) }
  scope :video, -> { where(mime_type: %w[video/mp4 vnd.voc/h264-lq vnd.voc/h264-hd vnd.voc/h264-sd vnd.voc/webm-hd video/ogg video/webm]) }
  scope :recorded_at, ->(conference) { joins(event: :conference).where(events: {'conference_id' => conference} ) }

  class << self

    def mime_type_slug(mime_type)
      humanized_mime_type(mime_type).to_param.downcase
    end

    def humanized_mime_type(mime_type)
      case mime_type
      when 'vnd.voc/h264-lq'
        'MP4 (LQ)'
      when 'vnd.voc/h264-sd'
        'MP4 (SD)'
      when 'vnd.voc/h264-hd'
        'MP4 (HD)'
      when 'vnd.voc/webm-hd'
        'WEBM (HD)'
      when 'audio/mpeg'
        'MP3'
      else
        mime_type.split('/')[1]
      end
    end

  end

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
    Recording.humanized_mime_type(mime_type)
  end

  def magnet_uri
    _, link = torrent_magnet_data
    link
  end

  def magnet_info_hash
    hash, _ = torrent_magnet_data
    hash
  end

  private

  def torrent_magnet_data
    MagnetLinkProvider.instance.fetch self
  end

end
