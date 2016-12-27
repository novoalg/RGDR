class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    has_many :posts

    VALID_AGE_REGEX = /[0-9][0-9]?[0-9]?/
    VALID_EMAIL_REGEX = /\w+\@\w+\.\w+/ #remember to trim whitespace when validating
    VALID_ZIP_REGEX = /\d{5}(-\d{4})?/
    VALID_PHONE_REGEX = /\d+/
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :age, presence: true, format: { with: VALID_AGE_REGEX }
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
    validates :address_line_one, presence: true
    validates :address_line_two, presence: true
    validates :city, presence: true 
    validates :state, presence: true #validate state from a list
    validates :zip, presence: true, format: { with: VALID_ZIP_REGEX }
    validates :phone, presence: true, format: { with: VALID_PHONE_REGEX }

    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

end
