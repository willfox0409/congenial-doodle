class Carnival 
    attr_reader :duration, :name, :rides

    def initialize(duration, name)
        @duration = duration
        @name = name 
        @rides = []
    end

    def add_ride(ride)
        @rides << ride 
    end

    def most_popular_ride
        @rides.max_by do |ride|
            ride.rider_log.values.sum
        end
    end

    def most_profitable_ride
        @rides.max_by do |ride|
            ride.total_revenue 
        end
    end

    def total_revenue
        @rides.sum do |ride|
            ride.total_revenue
        end
    end
end