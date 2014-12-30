class FeedBuilder

  def initialize(item_builder)
    @item_builder = item_builder
    @cache = ActiveSupport::Cache.lookup_store(:file_store, 'tmp/cache')
  end

  def add(conference, events)
    conference.mime_types do |mime_type, mime_type_name|
      name = "podcast-#{mime_type_name}"
      xml = @cache.fetch(cache_key(name, conference, events)) do
        Feeds::PodcastGenerator.generate events: events, query: :by_mime_type, config: {
          mime_type: mime_type,
          title: "#{conference.title} (#{mime_type_name})",
          channel_summary: "This feed contains all events from #{conference.acronym} as #{mime_type_name}"
        }
      end
      @item_builder.create_folder_feed_item(conference, identifier: name, content: xml)
    end

    # broadcatching
    conference.mime_types do |mime_type, mime_type_name|
      name = "broadcatching-#{mime_type_name}"
      xml = @cache.fetch(cache_key(name, conference, events)) do
        Feeds::BroadcatchingGenerator.generate events: events, query: :by_mime_type, config: {
          mime_type: mime_type,
          title: "#{conference.title} (#{mime_type_name})",
          channel_summary: "This feed contains all torrents for #{mime_type_name} from #{conference.acronym}"
        }
      end
      @item_builder.create_folder_feed_item(conference, identifier: name, content: xml, extension: 'rss')
    end
  end

  def apply
    # rss 1.0 last 100 feed
    events = Event.recent(100)
    xml = @cache.fetch(cache_key(:events100, events)) do
      Feeds::RDFGenerator.generate events: events, config: {
        title: 'last 100 events feed',
        channel_summary: "This feed the most recent 100 events"
      }
    end
    @item_builder.create_feed_item(xml, 'updates.rdf')

    # podcast_recent
    events = Event.newer(Time.now.ago(2.years))
    xml = @cache.fetch(cache_key(:events_two_years, events)) do
      Feeds::PodcastGenerator.generate events: events, config: {
        title: 'recent events feed',
        channel_summary: "This feed contains events from the last two years"
      }
    end
    @item_builder.create_feed_item(xml, 'podcast.xml')

    # podcast_archive
    events = Event.older(Time.now.ago(2.years))
    xml = @cache.fetch(cache_key(:events_older, events)) do
      Feeds::PodcastGenerator.generate events: events, config: {
        title: 'archive feed',
        channel_summary: "This feed contains events older than two years"
      }
    end
    @item_builder.create_feed_item(xml, 'podcast-archive.xml')

    # news atom feed
    news = News.all
    atom_feed = @cache.fetch(cache_key(:news, news)) do
      Feeds::NewsFeedGenerator.generate(news, options: {
        author: Settings.feeds['channel_owner'],
        about: 'http://media.ccc.de/',
        title: 'CCC TV - NEWS',
        feed_url: 'http://media.ccc.de/news.atom',
        icon: 'http://media.ccc.de/favicons.ico',
        logo: 'http://media.ccc.de/images/tv.png'
      })
    end
    @item_builder.create_feed_item(atom_feed, 'news.atom')
  end

  private

  def cache_key(identifier, *models)
    identifier.to_s + '_' + Digest::SHA1.hexdigest([models.flatten.map { |m| m.updated_at.to_i }].join(';'))
  end

end
