class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    after_create :confirmation_token
    has_many :blogs

    attr_accessor :remember_token, :password_confirmation
    VALID_AGE_REGEX = /\A[0-9][0-9]?[0-9]?\Z/
    VALID_EMAIL_REGEX = /\A\w+\@\w+\.\w+\Z/ #remember to trim whitespace when validating
    VALID_ZIP_REGEX = /\A\d{5}(-\d{4})?\Z/
    VALID_PHONE_REGEX = /\A\(?\d{3}\)?\-?\d{3}\-?\d{4}\Z/
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :age, presence: true, format: { with: VALID_AGE_REGEX }
    validates :email, uniqueness: true, presence: true, format: { with: VALID_EMAIL_REGEX }
#address
    validates :address_line_one, presence: true 
    validates_length_of :address_line_one, :maximum => 25

    validates_length_of :address_line_two, :maximum => 25
    validates :city, presence: true 
    validates :state, presence: true #validate state from a list
    validates :zip, presence: true, format: { with: VALID_ZIP_REGEX }
    validates :phone, presence: true, format: { with: VALID_PHONE_REGEX }
    validates :phone, length: { is: 10 }
    validates :hierarchy, presence: true, numericality: { :less_than_or_equal_to => 2, :greater_than => -1 }

    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
    validates :password, confirmation: true

    def remember
        self.remember_token = User.new_token
        self.update_attribute(:remember_digest, User.digest(remember_token))
    end

    def confirm(user, token)
        if !user.confirmed? && token == user.confirm_token
            self.update_attribute(:confirm_token, nil)
            self.update_attribute(:email_confirmed, true)
            true
        end
    end

    def confirmed?
        return false if !email_confirmed
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
    
    def full_name
        "#{self.first_name} #{self.last_name}"
    end

    def format_phone
        "(" + self.phone[0..2] + ")" + self.phone[3..5] + "-" + phone[6..9]
    end

    def admin?
        self.hierarchy == 0
    end

    class << self

        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end


        def new_token
            SecureRandom.urlsafe_base64
        end
    end

    private
        
        def confirmation_token
            if self.confirm_token.blank? && !self.email_confirmed
                self.update_attribute(:confirm_token, SecureRandom.urlsafe_base64.to_s)
            end
        end

end
