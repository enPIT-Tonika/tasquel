class Memo < ActiveRecord::Base
  validates :taskmemo, presence: true
end
