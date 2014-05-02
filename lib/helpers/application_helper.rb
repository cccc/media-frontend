module ApplicationHelper
  require 'nanoc/helpers/html_escape'
  include Nanoc::Helpers::HTMLEscape

  def recording_length_minutes(recording)
    if recording.length.present?
      recording.length / 60
    end
  end

end
