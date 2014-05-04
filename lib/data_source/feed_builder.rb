class FeedBuilder

  def initialize(item_builder)
    @item_builder = item_builder
  end

  def add(conference)
    xml = Feeds::PodcastGenerator.generate conference.events, config: {
      title: conference.title,
      channel_summary: "This feed contains all events from #{conference.acronym}"
    }
    @item_builder.create_folder_feed_item(conference, xml)
  end

  def apply
    # rss 1.0 last 100 feed
    xml = Feeds::RDFGenerator.generate Event.recent(100), config: {
      title: 'last 100 events feed',
      channel_summary: "This feed the most recent 100 events"
    }
    @item_builder.create_feed_item(xml, 'updates.rdf')

    # podcast_recent
    xml = Feeds::PodcastGenerator.generate Event.newer(Time.now.ago(2.years)), config: {
      title: 'recent events feed',
      channel_summary: "This feed contains events from the last two years"
    }
    @item_builder.create_feed_item(xml, 'podcast.xml')

    # podcast_archive
    xml = Feeds::PodcastGenerator.generate Event.older(Time.now.ago(2.years)), config: {
      title: 'archive feed',
      channel_summary: "This feed contains events older than two years"
    }
    @item_builder.create_feed_item(xml, 'podcast-archive.xml')
  end
end
