class Blog < ActiveRecord::Base
    has_many :comments
    belongs_to :user

    validates :content, presence: true
    validates :title, presence: true
    validates :active, presence: true
    validates :user_id, presence: true

    def localtime
        "Posted on #{self.created_at.localtime.strftime("%m/%d/%Y. At %I:%M %p")}. By #{self.user.full_name}"
    end

    def updated_time
        "Last updated #{self.updated_at.localtime.strftime("%m/%d/%Y. At %I:%M %p")}"
    end
end
