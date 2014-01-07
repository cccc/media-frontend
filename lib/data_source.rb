require 'active_record'

class MediaBackendDataSource < Nanoc3::DataSource

  identifier :media_backend

  def up
    ActiveRecord::Base.establish_connection(@site.config[:database])
  end

  def items
    items = []
    locations = Hash.new(0)

    # build folder and pages items
    Conference.all.each do |conference|
      conference_item = build_conference_item(conference)
      items << conference_item
      locations[conference.webgen_location] += 1

      conference.events.each do |event|
        items << build_event_item(conference, event)
      end
      
    end

    raise "duplicate location in conferences" if locations.any? { |k,v| v > 1 }
    locations = locations.keys

    # build connecting items
    root = build_navigation_tree(locations)
    walk_navigation_paths(root, []) { |path, childs|
      # skip last node
      next if locations.include? path
      items << build_browse_item(path, childs)
    }

    items << build_browse_item('/', root.keys)
    items
  end

  private 

  def build_conference_item(conference)
    Nanoc3::Item.new(
      "",
      { 
        title: conference.acronym, layout: 'browse-show-folder',
        conference: conference.attributes, events: conference.events
      },
      get_path(conference.webgen_location),
      binary: false
    )
  end

  def build_event_item(conference, event)
    description = ""
    if event.description.present?
      description = event.description
    end
    event_item = Nanoc3::Item.new(
      description,
      { 
        title: event.title, layout: 'browse-show-page',
        event: event.attributes, recordings: event.recordings
      },
      get_path(conference.webgen_location, event.slug),
      binary: false
    )
    #event_item.parent = conference_item # obsolete?
    #conference_item.children << event_item # obsolete?
    event_item
  end

  def build_browse_item(path, childs)
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

    Nanoc3::Item.new(
      "",
      { 
        title: path, layout: 'browse-index',
        folders: folders
      },
      get_path(path),
      binary: false
    )
  end

  def build_navigation_tree(locations)
    root = {}
    locations.each { |location|
      node = root
      next if location.nil?
      location.split(%r{/}).each { |path| 
        node[path] ||= {}
        node = node[path]
      }
    }
    root
  end

  def get_path(*parts)
    raise "nil found in item path" if parts.any? { |p| p.nil? }
    '/browse/' + parts.join('/') + '/'
  end

  def walk_navigation_paths(root, paths, &block)
    root.each { |k,leafs|
      p = paths.clone
      p << k
      block.call p.join('/'), leafs.keys
      walk_navigation_paths(leafs, p, &block)
    }
  end

end
