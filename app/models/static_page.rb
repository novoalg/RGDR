class StaticPage < ActiveRecord::Base
    validates :about_us, presence: true
    validates :home_block_one, presence: true
    validates :help, presence: true
    validates :contact_us, presence: true
    validates :sidebar, presence: true
    validates :woofs_for_help, presence:true
end
