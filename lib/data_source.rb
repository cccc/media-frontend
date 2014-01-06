require 'active_record'

class MediaBackendDataSource < Nanoc3::DataSource

  identifier :media_backend

  def up
    ActiveRecord::Base.establish_connection(@site.config[:database])
  end

  def items
    items = []

    Conference.all.each do |conference|
      conference_item = Nanoc3::Item.new(
        "",
        { conference: conference.attributes, events: conference.events },
        "/folder/#{conference.webgen_location}/",
        binary: false
      )
      items << conference_item

      conference.events.each do |event|
        description = ""
        if event.description.present?
          description = event.description
        end
        event_item = Nanoc3::Item.new(
          description,
          { event: event.attributes, recordings: event.recordings },
          "/folder/#{conference.webgen_location}/page/#{event.slug}/",
          binary: false
        )
        #event_item.parent = conference_item # obsolete?
        #conference_item.children << event_item # obsolete?
        items << event_item
      end
      
    end

    items
  end
end
