class Recording < ActiveRecord::Base
  belongs_to :event

  def get_recording_path
    File.join get_recording_dir, self.filename
  end

  def get_recording_dir
    self.folder ||= ""
    File.join self.event.conference.get_recordings_path, self.folder
  end


end
