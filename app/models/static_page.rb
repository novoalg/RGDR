class StaticPage < ActiveRecord::Base
    validates :about_us, presence: true
    validates :home_block_one, presence: true
    validates :help, presence: true
    validates :contact_us, presence: true
    validates :sidebar, presence: true
    validates :woofs_for_help, presence: true
    validates :event, presence: true
    validates :special_event, presence: true
    validates :adopt, presence: true
    validates :foster, presence: true
    validates :donate, presence: true
end
