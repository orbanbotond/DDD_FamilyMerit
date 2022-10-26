require 'securerandom'

class FullfillmentsController < ApplicationController
	def index
		@fullfillments = Fullfillment::Order.all
	end

	def deliver
		@delivery_id = params[:id]
		command_bus.(Fullfillments::Orders::Commands::Deliver.new(id: @delivery_id, should_fail: false, failure_reason: nil))
		redirect_to fullfillments_path
	end

	def do_not_deliver
		@delivery_id = params[:id]
		command_bus.(Fullfillments::Orders::Commands::Deliver.new(id: @delivery_id, should_fail: true, failure_reason: 'Decided Not To Deliver'))
		redirect_to fullfillments_path
	end

	def new
		@delivery = Deliveries::Create.new uuid: SecureRandom.uuid
	end

	def show
		@delivery_uuid = params[:id]
		@fullfillment = Fullfillment::Order.find_by fullfillment_id: @delivery_uuid
	end

	def create
		@delivery = Deliveries::Create.new delivery_creation_params
		if @delivery.valid?
			command_bus.(Fullfillments::Orders::Commands::Create.new(id: @delivery.uuid, amount: @delivery.quantity.to_i))
			redirect_to fullfillment_path(@delivery.uuid)
		else
			render :new, status: :unprocessable_entity, content_type: "text/html"
		end
	end

	private

	def delivery_creation_params
		params.require(:deliveries_create).permit(:uuid, :quantity)
	end
end
