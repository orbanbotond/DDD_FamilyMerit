require_relative '../spec_helper'
require 'securerandom'

RSpec.describe Merits::SpentTime do
	context 'invalid attributes' do
		it 'should ArgumentError arg is nil' do
			user_id = SecureRandom.hex(16)
			activity_id = SecureRandom.hex(16)
			time_in_minutes = 5

			expect { Merits::SpentTime.new(nil, time_in_minutes, activity_id) }.to raise_error(ArgumentError)
			expect { Merits::SpentTime.new(user_id, nil, activity_id) }.to raise_error(ArgumentError)
			expect { Merits::SpentTime.new(user_id, time_in_minutes, nil) }.to raise_error(ArgumentError)
			expect { Merits::SpentTime.new(user_id, -1, activity_id) }.to raise_error(ArgumentError)
			expect { Merits::SpentTime.new(user_id, 0, activity_id) }.to raise_error(ArgumentError)
		end
	end

	context 'uniqueness' do
		specify 'attributes alltogether the constitute the uniqueness' do
			user_id = SecureRandom.hex(16)
			activity_id = SecureRandom.hex(16)
			time_in_minutes = 5
			spent_time = Merits::SpentTime.new(user_id, time_in_minutes, activity_id)
			same_spent_time = Merits::SpentTime.new(user_id, time_in_minutes, activity_id)
			more_spent_time = Merits::SpentTime.new(user_id, time_in_minutes + 1, activity_id)
			another_activity_id =  SecureRandom.hex(16)
			spent_time_on_another_activity = Merits::SpentTime.new(user_id, time_in_minutes, another_activity_id)
			another_user_id =  SecureRandom.hex(16)
			spent_time_by_another_user = Merits::SpentTime.new(another_user_id, time_in_minutes, activity_id)

			expect(spent_time).to eql(same_spent_time)
			expect(spent_time).to_not eql(more_spent_time)
			expect(spent_time).to_not eql(spent_time_on_another_activity)
			expect(more_spent_time).to_not eql(spent_time_on_another_activity)
		end
	end
end