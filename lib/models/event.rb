class Event < ActiveRecord::Base
  belongs_to :conference
  has_many :recordings

  serialize :persons, Array
  serialize :tags, Array

  scope :promoted, ->(n) { where(promoted: true).order('updated_at desc').limit(n) }
  scope :recent, ->(n) { order('release_date desc').limit(n) }
  scope :newer, ->(date) { where("release_date > ?", date).order('release_date desc') }
  scope :older, ->(date) { where("release_date < ?", date).order('release_date desc') }

  def url
    "/browse/#{self.conference.webgen_location}/#{self.slug}.html"
  end

  def poster_url
    File.join(Settings.staticURL, 'media', self.conference.images_path, self.poster_filename) if self.poster_filename
  end

  # TODO thumbnail.js expects this to be equal thumb_url.gsub(/.jpg$/, '.gif')
  def gif_url
    File.join Settings.staticURL, 'media', self.conference.images_path, self.gif_filename
  end

  def thumb_url
    File.join Settings.staticURL, 'media', self.conference.images_path, self.thumb_filename
  end

end
