class TagPages

  def initialize
    @tags = Hash.new { |h,k| h[k] = [] }
  end
  attr_reader :tags

  def add(events)
    events.each { |event|
      event.tags.each { |tag|
        @tags[tag.strip] << event
      }
    }
  end

  def create_items(item_builder)
    @tags.each { |tag, events|
      item_builder.tag_item(tag, events)
    }
  end

end
