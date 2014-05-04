require 'active_record'

class MediaBackendDataSource < Nanoc3::DataSource

  identifier :media_backend

  def up
    ActiveRecord::Base.establish_connection(@site.config[:database])
  end

  def items
    item_builder = ItemBuilder.new
    tag_pages = TagPages.new
    location_pages = LocationPages.new
    feed_builder = FeedBuilder.new(item_builder)

    Conference.all.each do |conference|
      # conference folders
      item_builder.create_conference_item(conference)
      location_pages.add(conference.webgen_location)

      # event pages
      conference.events.each do |event|
        item_builder.create_event_item(event)
      end

      tag_pages.add(conference.events)
      feed_builder.add(conference)
    end

    raise "duplicate location in conferences" if location_pages.duplicate?

    # build tag pages
    tag_pages.apply(item_builder)

    # build connecting folder items
    location_pages.apply(item_builder)

    feed_builder.apply

    item_builder.items
  end

end
