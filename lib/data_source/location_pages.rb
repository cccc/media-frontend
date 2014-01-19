class LocationPages
  def initialize
    @locations = Hash.new(0)
  end

  def add(location)
    @locations[location] += 1
  end

  def create_items(item_builder)
    locations = @locations.keys

    root = build_navigation_tree(locations)
    walk_navigation_paths(root, []) { |path, childs|
      # skip last node
      next if locations.include? path
      item_builder.browse_item(path, childs)
    }

    item_builder.browse_item('/', root.keys)
  end

  def duplicate?
    @locations.any? { |k,v| v > 1 }
  end

  private

  def build_navigation_tree(locations)
    root = {}
    locations.each { |location|
      node = root
      next if location.nil?
      location.split(%r{/}).each { |path| 
        node[path] ||= {}
        node = node[path]
      }
    }
    root
  end

  def walk_navigation_paths(root, paths, &block)
    root.each { |k,leafs|
      p = paths.clone
      p << k
      block.call p.join('/'), leafs.keys
      walk_navigation_paths(leafs, p, &block)
    }
  end

end
