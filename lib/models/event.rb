class Event < ActiveRecord::Base
  belongs_to :conference
  has_many :recordings

  serialize :persons, Array
  serialize :tags, Array

  def url
    "/browse/#{self.conference.webgen_location}/#{self.slug}.html"
  end

  def poster_url
    "http://static.media.ccc.de/media/#{self.poster_filename}" if self.poster_filename
  end

  def gif_url
    File.join 'http://static.media.ccc.de/media/', self.conference.images_path, self.gif_filename
  end

  def thumb_url
    File.join 'http://static.media.ccc.de/media/', self.conference.images_path, self.thumb_filename
  end

end
