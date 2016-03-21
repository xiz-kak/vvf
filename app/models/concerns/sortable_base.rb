module SortableBase
  extend ActiveSupport::Concern

  included do

    def self.sorted
      order(:sort_order)
    end
  end
end
