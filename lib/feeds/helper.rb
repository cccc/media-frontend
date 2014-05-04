module Feeds

  module Helper

    def merge_config(config)
      keep = [ :title, :channel_summary ]
      @config.channel_title = [ @config.channel_title, config[:title] ].join(' - ')
      @config.channel_summary += config[:channel_summary]

      config.each { |k,v|
        next if keep.include? k
        @config[k] = v
      }
    end

    def get_item_title(event)
      conference = event.conference
      title = ''
      if conference.title.present? 
        title = conference.title
      elsif conference.acronym.present?
        title = conference.acronym
      end
      title += ": "
      if event.title
        title += event.title
      else
        title += event.slug
      end
      title
    end

    def get_item_description(event)
      description = []
      description << event.description or event.subtitle

      link = event.link
      description << "about this event: #{link}\n" if link

      # file = 'src/browse/bla.page'
      url = @config['base_url'] + event.slug + '.html'
      description << "event on media: #{url}\n"

      description.join
    end


    def preferred_recording(event, order=%w{video/mp4 video/webm video/ogg video/flv})
      recordings = recordings_by_mime_type(event)
      return if recordings.empty?
      order.each { |mt|
        return recordings[mt] if recordings.has_key?(mt)
      }
      recordings.first[1]
    end

    private

    def recordings_by_mime_type(event)
      Hash[event.recordings.map { |r| [r.mime_type, r] }]
    end

  end

end
