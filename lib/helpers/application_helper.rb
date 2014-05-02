module ApplicationHelper
  require 'nanoc/helpers/html_escape'
  include Nanoc::Helpers::HTMLEscape

  def recording_length_minutes(recording)
    if recording.length.present?
      "#{recording.length / 60}min"
    end
  end

  def audio_ready_icon(recordings)
    if recordings.audio.present?
      recording = recordings.audio.first
      %'<a class="icon" href="#{recording.url}"><img src="/images/audio_ready_icon.png" alt="audio-only version available, too"/></a>'
    end
  end

  def video_quality_icon(recordings)
    if recordings.video.present?
      recording = recordings.max { |recording| recording.width }
      if recording.width >= 1280 and recording.height >= 720
        %'<img src="/images/hd_ready_icon.png" alt="720p resolution"/>'
      elsif recording.width >= 704 and recording.height >= 480
        %'<img src="/images/dvd_ready_icon.png" alt="dvd resolution"/>'
      end
    end
  end

  def aspect_ratio_width(conference, high=true)
    case conference.aspect_ratio
    when /16:9/
      high ? '640' : '188'
    when /4:3/
      high ? '400' : '120'
    else
    end
  end

  def aspect_ratio_height(conference, high=true)
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
    date.strftime("%Y-%m-%d %H:%M") if date
  end


end