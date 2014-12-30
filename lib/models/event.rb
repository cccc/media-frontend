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

  def download_url
    "/browse/#{self.conference.webgen_location}/#{self.slug}/download/#download"
  end

  def poster_url
    File.join(Settings.staticURL, 'media', self.conference.images_path, self.poster_filename) if self.poster_filename
  end

  def thumb_url
    File.join Settings.staticURL, 'media', self.conference.images_path, self.thumb_filename
  end

  def tags
    read_attribute(:tags).compact.collect { |x| x.strip }
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

  def linked_persons_text
    if self.persons.length == 0
      'n/a'
    elsif self.persons.length == 1
      linkify_persons(self.persons)[0]
    else
      persons = linkify_persons(self.persons)
      persons = persons[0..-3] + [persons[-2..-1].join(' and ')]
      persons.join(', ')
    end
  end

  def linkify_persons(persons)
    persons.map { |person| '<a href="/search/?q='+CGI.escapeHTML(CGI.escape(person))+'">'+CGI.escapeHTML(person)+'</a>' }
  end

  def persons_icon
    if self.persons.length <= 1
      'fa-user'
    else
      'fa-group'
    end
  end

  def preferred_recording(order: Recording::PREFERRED_VIDEO, mime_type: nil)
    recordings = recordings_by_mime_type
    return if recordings.empty?
    order.each { |mt|
      return recordings[mt] if recordings.has_key?(mt)
    }
    recordings.first[1]
  end

  def by_mime_type(order: nil, mime_type: 'video/mp4')
    recordings.downloaded.by_mime_type(mime_type).first
  end

  private

  def recordings_by_mime_type
    Hash[recordings.downloaded.map { |r| [r.mime_type, r] }]
  end

end
