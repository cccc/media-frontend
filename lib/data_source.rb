require 'active_record'

class MediaBackendDataSource < Nanoc3::DataSource

  identifier :media_backend

  def up
    ActiveRecord::Base.establish_connection(@site.config[:database])
  end

  def items
    tags = Hash.new { |h,k| h[k] = [] }

    item_builder = ItemBuilder.new
    locations = Locations.new

    Conference.all.each do |conference|
      # conference folders
      item_builder.conference_item(conference)
      locations.add(conference.webgen_location)

      # event pages
      conference.events.each do |event|
        item_builder.event_item(event)
      end

      collect_tags(tags, conference.events)
    end

    raise "duplicate location in conferences" if locations.duplicate?

    # build tag pages
    tags.each { |tag, events|
      item_builder.tag_item(tag, events)
    }

    # build connecting folder items
    locations.create_items(item_builder)

    item_builder.items
  end

  private 

  def collect_tags(tags, events)
    events.each { |event|
      event.tags.each { |tag|
        tags[tag.strip] << event
      }
    }
  end

end
