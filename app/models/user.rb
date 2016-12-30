class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    has_many :posts

    VALID_AGE_REGEX = /\A[0-9][0-9]?[0-9]?\Z/
    VALID_EMAIL_REGEX = /\A\w+\@\w+\.\w+\Z/ #remember to trim whitespace when validating
    VALID_ZIP_REGEX = /\A\d{5}(-\d{4})?\Z/
    VALID_PHONE_REGEX = /\A\d{10}\Z/
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :age, presence: true, format: { with: VALID_AGE_REGEX }
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
#address
    validates :address_line_one, presence: true 
    validates_length_of :address_line_one, :maximum => 25

    validates_length_of :address_line_two, :maximum => 25
    validates :city, presence: true 
    validates :state, presence: true #validate state from a list
    validates :zip, presence: true, format: { with: VALID_ZIP_REGEX }
    validates :phone, presence: true, format: { with: VALID_PHONE_REGEX }
    validates :phone, length: { is: 10 }
    #validates :active, presence: true, numerically: { :less_than_or_equal_to => 1, :greater_than => -1 }

    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def format_phone
        "(" + self.phone[0..2] + ")" + self.phone[3..5] + "-" + phone[6..9]
    end
end
