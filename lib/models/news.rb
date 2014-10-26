class News < ActiveRecord::Base
  scope :recent, ->(n) { order('date desc').limit(n) }
  
  def date_formatted
    self.date.strftime("%d.%m.%Y")
  end
end
