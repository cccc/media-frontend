class ItemBuilder

  def initialize
    @items = []
  end
  attr_reader :items

  def create_conference_item(conference, events)
    ['', 'name', 'duration', 'date'].each do |sorting|
      @items << Nanoc3::Item.new(
        "",
        {
          title: conference_title(conference), layout: 'browse-show-folder',
          conference: conference, events: sorting_events(events, sorting),
          sorting: sorting
        },
        get_path([conference.webgen_location, "#{sorting}"]),
        binary: false
      )
    end
  end

  def create_event_item(event)
    description = ""
    if event.description.present?
      description = event.description
    end

    event_item = Nanoc3::Item.new(
      description,
      {
        title: event.title, layout: 'browse-show-page',
        tags: event.tags.map { |t| t.strip },
        conference: event.conference,
        event: event,
        video_recordings: event.recordings.downloaded.video,
        audio_recordings: event.recordings.downloaded.audio
      },
      get_path(event.conference.webgen_location, event.slug),
      binary: false
    )

    @items << event_item


    event_download_item = Nanoc3::Item.new(
      description,
      {
        title: event.title, layout: 'browse-download-page',
        tags: event.tags.map { |t| t.strip },
        conference: event.conference,
        event: event,
        video_recordings: event.recordings.downloaded.video,
        audio_recordings: event.recordings.downloaded.audio
      },
      get_path(event.conference.webgen_location, event.slug)+'download/',
      binary: false
    )

    @items << event_download_item
  end

  def create_browse_item(path, childs)
    folders = []
    childs.each { |child|
      if path == '/'
        location = child
      else
        location = File.join(path, child)
      end
      folder = Folder.new(location: location)
      res = Conference.where(webgen_location: location)
      folder.conference = res.first unless res.nil? or res.empty?
      folders << folder
    }

    title = path
    if path == "/"
      title = "Browse by category"
    end

    @items << Nanoc3::Item.new(
      "",
      {
        title: title, layout: 'browse-index',
        folders: folders
      },
      get_path(path),
      binary: false
    )
  end

  def create_tag_item(tag, events)
    @items << Nanoc3::Item.new(
      "",
      {
        title: tag, layout: 'browse-show-tags',
        tag: true,
        events: events
      },
      get_path('tags', tag),
      binary: false
    )
  end

  def create_feed_item(content, filename)
    identifier, extension = filename.split('.')
    @items << Nanoc3::Item.new(
      content,
      {
        extension: extension
      },
      "/#{identifier}/",
      binary: false
    )
  end

  def create_folder_feed_item(conference, content: '', identifier: 'podcast', extension: 'xml')
    @items << Nanoc3::Item.new(
      content,
      {
        extension: extension
      },
      get_path(conference.webgen_location, identifier),
      binary: false
    )
  end

  private

  def conference_title(conference)
    if conference.title.present?
      conference.title
    else
      conference.acronym
    end
  end

  def get_path(*parts)
    raise "nil found in item path" if parts.any? { |p| p.nil? }
    '/browse/' + parts.join('/') + '/'
  end

  def sorting_events(events, criteria)
    case criteria
    when 'name'
      events.sort_by{ |e| e.title }
    when 'duration'
      events.sort_by{ |e| e.recordings.downloaded.first.length.nil? ? 0 : e.recordings.downloaded.first.length }.reverse
    when 'date'
      events.sort_by{ |e| date(e) }
    else
      events
    end
  end

end
