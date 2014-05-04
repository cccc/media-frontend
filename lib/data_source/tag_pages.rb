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

  def apply(item_builder)
    @tags.each { |tag, events|
      item_builder.create_tag_item(tag, events)
    }
  end

end
