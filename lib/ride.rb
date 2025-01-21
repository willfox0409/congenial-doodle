class Ride 
    attr_reader :name, 
                :min_height, 
                :admission_fee, 
                :excitement, 
                :total_revenue, 
                :rider_log

    def initialize(info)
        @name = info[:name]
        @min_height = info[:min_height]
        @admission_fee = info[:admission_fee]
        @excitement = info[:excitement]
        @total_revenue = 0
        @rider_log = {}
    end

    def board_rider(visitor) 
        if visitor.tall_enough?(@min_height) && visitor.preferences.include?(@excitement)
            if @rider_log[visitor]
                @rider_log[visitor] += 1
            else
                @rider_log[visitor] = 1
            end

            visitor.spending_money -= @admission_fee

            @total_revenue += @admission_fee
        end
    end
end