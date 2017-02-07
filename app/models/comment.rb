class Comment < ApplicationRecord
    belongs_to :blog
    belongs_to :user
    has_many :replies, class_name: 'Comment', foreign_key: 'reply_id'

    validates :content, presence: true
    validates :user_id, presence: true
    validates :blog_id, presence: true

end
