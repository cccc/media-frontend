class ItemBuilder

  def initialize
    @items = []
  end
  attr_reader :items

  def create_conference_item(conference)
    @items << Nanoc3::Item.new(
      "",
      { 
        title: conference.acronym, layout: 'browse-show-folder',
        conference: conference, events: conference.events
      },
      get_path(conference.webgen_location),
      binary: false
    )
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
    #event_item.parent = conference_item # obsolete?
    #conference_item.children << event_item # obsolete?
    @items << event_item
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

    @items << Nanoc3::Item.new(
      "",
      { 
        title: path, layout: 'browse-index',
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

  def create_folder_feed_item(conference, content)
    @items << Nanoc3::Item.new(
      content,
      {
        extension: 'xml'
      },
      get_path(conference.webgen_location, 'podcast'),
      binary: false
    )
  end

  private 

  def get_path(*parts)
    raise "nil found in item path" if parts.any? { |p| p.nil? }
    '/browse/' + parts.join('/') + '/'
  end


end
