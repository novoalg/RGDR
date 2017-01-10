class Event < ActiveRecord::Base
    validates :name, presence: true, length: { in: 1..200 }
    validates :information, presence: true, length: { in: 0..3000 }
    validates :special, inclusion: { in: [true,false] }
    validates :location, presence: true, length: { in: 0..100}
    validates :time, presence: true, length: { in: 1..100 }
    validates :date, presence: true

    def date_format
        self.date.strftime("%m/%d/%Y")
    end

end
