require './lib/visitor'
require './lib/ride'
require './lib/carnival'

RSpec.describe Carnival do 
    before(:each) do 
        @visitor1 = Visitor.new('Bruce', 54, '$10')
        @visitor2 = Visitor.new('Tucker', 36, '$5')
        @visitor3 = Visitor.new('Penny', 64, '$15')

        @ride1 = Ride.new(
            { 
                name: 'Carousel', 
                min_height: 24, 
                admission_fee: 1, 
                excitement: :gentle 
            }
        )

        @ride2 = Ride.new(
            { 
                name: 'Ferris Wheel', 
                min_height: 36, 
                admission_fee: 5, 
                excitement: :gentle 
            }
        )

        @ride3 = Ride.new(
            { 
                name: 'Roller Coaster', 
                min_height: 54, 
                admission_fee: 2, 
                excitement: :thrilling 
            }
        )

        @carnival1 = Carnival.new(14, "Carny Heaven")
    end

    describe '#initialize' do 
        it 'exists' do 
            expect(@carnival1).to be_a(Carnival)
        end

        it 'has attributes' do 
            expect(@carnival1.duration).to eq(14)
            expect(@carnival1.name).to eq("Carny Heaven")
            expect(@carnival1.rides).to eq([])
        end
    end

    describe '#add_ride' do 
        it 'adds rides to the carnival' do 
            @carnival1.add_ride(@ride1)
            @carnival1.add_ride(@ride2)
        
            expect(@carnival1.rides).to eq([@ride1, @ride2])
        end
    end

    describe '#most_popular_ride' do 
        it 'determines the most popular ride by checking the rider_log' do 
            @carnival1.add_ride(@ride1)
            @carnival1.add_ride(@ride2)
            @visitor1.add_preference(:gentle)
            @visitor2.add_preference(:gentle)
        
            @ride1.board_rider(@visitor1)
            @ride1.board_rider(@visitor2)
            @ride1.board_rider(@visitor1) #3 total riders
        
            @ride2.board_rider(@visitor2) #1 total rider
        
            expect(@carnival1.most_popular_ride).to eq(@ride1)
        end
    end

    describe '#most_profitable_ride' do
        it 'determines the most profitable ride based on total_revenue' do
            @carnival1.add_ride(@ride1)
            @carnival1.add_ride(@ride2)
            @visitor1.add_preference(:gentle)
            @visitor2.add_preference(:gentle)

            @ride1.board_rider(@visitor1) #total_revenue = 1 ($1)
            @ride2.board_rider(@visitor2) #total_revenue = 5 ($5)

            expect(@carnival1.most_profitable_ride).to eq(@ride2)
        end
    end

    describe '#total_revenue' do 
        it "calculates the total revenue by adding all of the rides' total revenue" do 
            @carnival1.add_ride(@ride1)
            @carnival1.add_ride(@ride2)
            @visitor1.add_preference(:gentle)
            @visitor2.add_preference(:gentle)
        
            @ride1.board_rider(@visitor1) #revenue = 1
            @ride1.board_rider(@visitor2) #revenue = 1
            @ride2.board_rider(@visitor2) #revenue = 5
        
            expect(@carnival1.total_revenue).to eq(7) #1 + 1 + 5 = 7
        end
    end
end

