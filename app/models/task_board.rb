class TaskBoard < ActiveRecord::Base
 belongs_to :family
 validates :taskText, presence: true
end
