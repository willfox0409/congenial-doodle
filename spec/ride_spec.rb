require './lib/visitor'
require './lib/ride'

RSpec.describe Ride do 
    before(:each)do 
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
    end

    describe '#initialize' do 
        it 'exists' do 
            expect(@ride1).to be_a(Ride)
        end
    end

    describe '#attributes' do 
        it 'has attributes' do 
            expect(@ride1.name).to eq('Carousel')
            expect(@ride1.min_height).to eq(24)
            expect(@ride1.admission_fee).to eq(1)
            expect(@ride1.excitement).to eq(:gentle)
            expect(@ride1.total_revenue).to eq(0)
        end
    end

    describe '#board_rider' do 
        it 'logs riders and updates spending money and revenue correctly' do 
            @visitor1.add_preference(:gentle)
            @visitor2.add_preference(:gentle)

            @ride1.board_rider(@visitor1)
            @ride1.board_rider(@visitor2)
            @ride1.board_rider(@visitor1) #double-ride

            expect(@ride1.rider_log).to eq({@visitor1 => 2, @visitor2 => 1})
            expect(@visitor1.spending_money).to eq(8)
            expect(@visitor2.spending_money).to eq(4)
            expect(@ride1.total_revenue).to eq(3) #
        end

        it 'prevents visitors without matching preferences to enter the ride' do 
            @visitor1.add_preference(:thrilling) 

            @ride1.board_rider(@visitor1) #:gentle and :thrilling don't match 

            expect(@ride1.rider_log).to eq({}) #unchanged
            expect(@visitor1.spending_money).to eq(10) #unchanged
            expect(@ride1.total_revenue).to eq(0) #unchanged
        end

        it "prevents visitors who don't meet minimum height requirement to enter the ride" do 
            @visitor4 = Visitor.new('Will', 23, '$5') #Height is less than 24
            @visitor4.add_preference(:gentle)

            @ride1.board_rider(@visitor4)

            expect(@ride1.rider_log).to eq({}) #unchanged
            expect(@visitor4.spending_money).to eq(5) # unchanged
            expect(@ride1.total_revenue).to eq(0) #unchanged
        end

        it 'logs the visitors who meet minimum height requirement and excitement preferences' do
            @visitor1.add_preference(:gentle)
            @visitor2.add_preference(:gentle)

            @ride1.board_rider(@visitor1)
            @ride1.board_rider(@visitor2)
            @ride1.board_rider(@visitor1) #double-ride again

            expect(@ride1.rider_log).to eq({
                @visitor1 => 2,
                @visitor2 => 1
            })
            expect(@visitor1.spending_money).to eq(8) 
            expect(@visitor2.spending_money).to eq(4) 
            expect(@ride1.total_revenue).to eq(3)     
        end

        it 'logs visitors for different rides depending on preferences and height' do
            @visitor2.add_preference(:thrilling)
            @visitor3.add_preference(:thrilling)

            @ride3.board_rider(@visitor1) #didn't add :thirlling preference
            @ride3.board_rider(@visitor2) #adds :thrilling but doesn't meet min height
            @ride3.board_rider(@visitor3) 

            expect(@ride3.rider_log).to eq({ #only @visitor 3 boards and is logged
                @visitor3 => 1
            })
            expect(@visitor1.spending_money).to eq(10) #unchanged, didn't include matching preference
            expect(@visitor2.spending_money).to eq(5) #unchanged, didn't board due to height
            expect(@visitor3.spending_money).to eq(13) #15 - 2
            expect(@ride3.total_revenue).to eq(2) #1 rider => $2 admission 
        end
    end
end
