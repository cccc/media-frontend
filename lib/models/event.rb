class Event < ActiveRecord::Base
  belongs_to :conference
  has_many :recordings

  serialize :persons, Array
  serialize :tags, Array

  scope :promoted, ->(n) { where(promoted: true).order('updated_at desc').limit(n) }
  scope :recent, ->(n) { order('release_date desc').limit(n) }
  scope :newer, ->(date) { where("release_date > ?", date).order('release_date desc') }
  scope :older, ->(date) { where("release_date < ?", date).order('release_date desc') }

  scope :recorded_at, ->(conference) {
    joins(:recordings, :conference)
    .where(conferences: { id: conference })
    .where(recordings: { state: 'downloaded', mime_type: Recording::HTML5 }) 
    .group(:"events.id")
  }
  
  def title
    read_attribute(:title).strip
  end

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

  def tags
    read_attribute(:tags).compact
  end

  def persons_text
    if self.persons.length == 0
      'n/a'
    elsif self.persons.length == 1
      self.persons[0]
    else
      persons = self.persons[0..-3] + [self.persons[-2..-1].join(' and ')]
      persons.join(', ')
    end
  end
  
  def persons_icon
    if self.persons.length <= 1
      'fa-user'
    else
      'fa-group'
    end
  end
end
