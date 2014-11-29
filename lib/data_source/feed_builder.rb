class FeedBuilder

  def initialize(item_builder)
    @item_builder = item_builder
    @cache = ActiveSupport::Cache.lookup_store(:file_store, 'tmp/cache')
  end

  def add(conference, events)
    xml = @cache.fetch(cache_key(:conference, conference, events)) do
      Feeds::PodcastGenerator.generate events, config: {
        title: conference.title,
        channel_summary: "This feed contains all events from #{conference.acronym}"
      }
    end
    @item_builder.create_folder_feed_item(conference, xml)
  end

  def apply
    # rss 1.0 last 100 feed
    events = Event.recent(100)
    xml = @cache.fetch(cache_key(:events100, events)) do
      Feeds::RDFGenerator.generate events, config: {
        title: 'last 100 events feed',
        channel_summary: "This feed the most recent 100 events"
      }
    end
    @item_builder.create_feed_item(xml, 'updates.rdf')

    # podcast_recent
    events = Event.newer(Time.now.ago(2.years))
    xml = @cache.fetch(cache_key(:events_two_years, events)) do
      Feeds::PodcastGenerator.generate events, config: {
        title: 'recent events feed',
        channel_summary: "This feed contains events from the last two years"
      }
    end
    @item_builder.create_feed_item(xml, 'podcast.xml')

    # podcast_archive
    events = Event.older(Time.now.ago(2.years))
    xml = @cache.fetch(cache_key(:events_older, events)) do
      Feeds::PodcastGenerator.generate events, config: {
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
    Digest::SHA1.hexdigest([identifier, models.flatten.map { |m| m.updated_at.to_i }].join(';'))
  end

end
