class MagnetLinkProvider
  include Singleton

  def fetch(recording)
		begin
			magnet = download(recording).chomp
			[magnet[20..59], magnet.to_s]
		rescue OpenURI::HTTPError => ex
			STDERR.puts "Failed to download URL #{recording.url} : #{ex.message}"
			[nil,nil]
		end
  end

  private

  def cache
    @cache ||= ActiveSupport::Cache.lookup_store(:file_store, 'tmp/cache_magnets')
  end

  def download(recording)
    cache.fetch(cache_key(:magnet, recording)) do
      #`curl #{recording.url}?magnet`
      download_uri("#{recording.url}?magnet")
    end
  end

  def cache_key(identifier, model)
    identifier.to_s + '_' + Digest::SHA1.hexdigest([model.id, model.updated_at.to_i].join(';'))
  end

  def download_uri(url)
    content = ''
    url = url.gsub(/ /, '%20')
    uri = URI(URI.escape(url))

    if uri.scheme.nil?
      uri = URI('https:' + uri.to_s)
    end

    if uri.scheme == 'file'
      File.open(uri.path, 'r:UTF-8') { |f| content = f.read }
    else
      content = open(url).read
    end
    content.to_s
  end
end

