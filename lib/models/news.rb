class News < ActiveRecord::Base
  scope :recent, ->(n) { order('date desc').limit(n) }

  def header
    self.date.strftime("%Y-%m-%d") + ': ' + self.title
  end
end
