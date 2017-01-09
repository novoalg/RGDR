class Blog < ActiveRecord::Base
    has_many :comments
    belongs_to :user

    validates :content, presence: true
    validates :title, presence: true
    validates :active, presence: true
    validates :user_id, presence: true

    def localtime
        self.created_at.localtime.strftime("%m/%d/%Y. At %I:%M %p")
    end
end
