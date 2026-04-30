class Post < ApplicationRecord
  after_initialize do
    self.likes ||= 0
  end
end
