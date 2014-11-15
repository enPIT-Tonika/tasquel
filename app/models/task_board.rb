class TaskBoard < ActiveRecord::Base
 include RankedModel
 ranks :row_order
 belongs_to :family
 validates :taskText, presence: true
end
