module ApplicationHelper
  require 'nanoc/helpers/html_escape'
  include Nanoc::Helpers::HTMLEscape

  def oembed_url(identifier)
    Settings.oembedURL + identifier[0..-2] + '.html&format=json'
  end

  def event_page_or_folder(item)
    return if @item.identifier.include? '/tags/'
    trail = breadcrumbs_trail
    return unless trail.count > 2 or @item.identifier.include? '/browse/'
    trail = trail[0..-2] if @item.identifier.include? '/download/'
    yield trail
  end

  def video_tag_sources(recordings, order=MimeType::WEB_PREFERRED_VIDEO)
    scores = {}
    recordings.select { |r| order.include? r.mime_type }.each { |r|
      pos = order.index r.mime_type
      fail r.mime_type unless pos
      if scores.has_key? r.display_mime_type
        scores[r.display_mime_type] = pos unless scores[r.display_mime_type] < pos
      else
        scores[r.display_mime_type] = pos
      end
    }
    scores.map { |_, pos|
      mime_type = order[pos]
      recordings.detect { |r| r.mime_type == mime_type }
    }
  end

  def keywords
    if @item[:event] and @item[:event].tags
     [ @item[:event].tags, Settings.header['keywords']].join(', ')
    else
      Settings.header['keywords']
    end
  end

  def recording_length(recordings)
    return unless recordings.present?
    recording = recordings.select { |r| r.length.present? }.first
    recording_length_minutes(recording) unless recording.nil?
  end

  def recording_length_minutes(recording)
    if recording.length > 0
      "#{recording.length / 60} min"
    end
  end

  def flash(recordings)
    url = recordings.select { |recording| recording.display_mime_type == 'video/mp4' }.first.try(:url)
    if url.present?
      h(url)
    elsif recordings.present?
      h(recordings.first.url)
    else
      # :(
      ''
    end
  end

  def aspect_ratio_width(high=true)
    conference = @item[:conference]
    case conference.aspect_ratio
    when /16:9/
      high ? '640' : '188'
    when /4:3/
      high ? '400' : '120'
    else
    end
  end

  def aspect_ratio_height(high=true)
    conference = @item[:conference]
    case conference.aspect_ratio
    when /16:9/
      high ? '360' : '144'
    when /4:3/
      high ? '300' : '90'
    else
    end
  end

  def date(event)
    date = event.release_date || event.date
    date.strftime("%Y-%m-%d") if date
  end

  def datetime(event)
    date = event.release_date || event.date
    date.strftime("%Y-%m-%d %H:%M") if date
  end

  def parse_url_host(urlish)
    begin
      URI.parse(@item[:event].link).host()
    rescue URI::InvalidURIError
      return ""
    end
  end
end
