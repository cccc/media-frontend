class Recording < ActiveRecord::Base
  belongs_to :event

  scope :downloaded, -> { where(state: 'downloaded') }
  scope :by_mime_type, ->(mime_type) { where(mime_type: mime_type) }
  scope :audio, -> { where(mime_type: %w[audio/ogg audio/mpeg audio/opus]) }
  scope :video, -> { where(mime_type: %w[vnd.voc/mp4-web vnd.voc/webm-web video/mp4 vnd.voc/h264-lq vnd.voc/h264-hd vnd.voc/h264-sd vnd.voc/h264-4k vnd.voc/webm-hd vnd.voc/webm-4k video/ogg video/webm]) }
  scope :recorded_at, ->(conference) { joins(event: :conference).where(events: {'conference_id' => conference} ) }

  def url
    File.join self.event.conference.recordings_url, self.folder || '', self.filename
  end

  def torrent_url
    url + '.torrent'
  end

  def display_mime_type
    MimeType.display_mime_type(mime_type)
  end

  def filetype
    MimeType.humanized_mime_type(mime_type)
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
