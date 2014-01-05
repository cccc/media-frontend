require 'active_record'

class MediaBackendDataSource < Nanoc3::DataSource

  identifier :media_backend

  def up
    ActiveRecord::Base.establish_connection(@site.config[:database])
  end

  # TODO add static pages
  # TODO find template
  # TODO write file.html instead of file/index.html
  # TODO add recordings

  def items
    items = []

    Conference.all.each do |conference|
      conference_item = Nanoc3::Item.new(
        conference.acronym,
        { :title => conference.title },
        "/folder/#{conference.webgen_location}/",
        binary: false
      )
      items << conference_item

      conference.events.each do |event|
        event_item = Nanoc3::Item.new(
          event.guid, # content for page
          event.attributes, # attributes for layout
          "/folder/#{conference.webgen_location}/page/#{event.slug}/",
          binary: false
        )
        event_item.parent = conference_item # obsolete?
        conference_item.children << event_item # obsolete?
        items << event_item
      end
      
    end

    items
  end
end
