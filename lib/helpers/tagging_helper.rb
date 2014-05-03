# Set the tags attribute on items to use this helper
module TaggingHelper

  require 'nanoc/helpers/html_escape'
  include Nanoc::Helpers::HTMLEscape

  # available tags
  def all_tags
    @items.map { |i| i[:tags] }.flatten.uniq
  end

  # link to tag page
  def link_for(tag, prefix: '/browse/tags/', css: '')
    %[<a href="#{h prefix}#{h tag}.html" rel="tag" class="#{css}">#{h tag}</a>]
  end

  # 
  def tag_cloud(prefix: '/browse/tags/')
    return if @items.nil?
    tags_hash.map { |tag, items|
      link_for tag, prefix: prefix, css: css_class_by_size(items.count)
    }
  end

  private

  # TODO define more classes
  def css_class_by_size(n)
    'small'
  end

  def tags_hash
    tags = Hash.new { |h,k| h[k] = [] }
    @items.each do |i| 
      next unless i[:tags]
      i[:tags].each { |t| tags[t] << i }
    end
    tags
  end

end
