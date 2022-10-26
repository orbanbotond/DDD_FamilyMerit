module Deliveries
	class Create
	 include ActiveModel::Model

	  attr_accessor :uuid
	  attr_accessor :quantity

		validates :uuid, presence: true
		validates :quantity, presence: true,
											   numericality: { greater_than_or_equal_to: 1 }
	end
end
