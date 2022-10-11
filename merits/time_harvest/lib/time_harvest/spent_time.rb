module Merits
	SpentTime = Struct.new(:user_id, :time_in_minutes, :activity_id) do
		def initialize(user_id, time_in_minutes, activity_id)
			raise ArgumentError if user_id.nil?
			raise ArgumentError if time_in_minutes.nil?
			raise ArgumentError if activity_id.nil?
			raise ArgumentError if time_in_minutes <= 0

			super
		end
	end
end
