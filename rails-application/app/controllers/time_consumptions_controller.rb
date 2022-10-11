class TimeConsumptionsController < ApplicationController
	def new
		accounts = [{id: '59a1e379c3574f3be77dd04eee5bcedf', name:'Boti'}]
		activities = [{id: 0, name:'Software Development'}]

		@accounts = accounts.map do |account|
			OpenStruct.new account
		end
		@activities = activities.map do |account|
			OpenStruct.new account
		end
	end

	def create
    cmd = TimeHarvest::ConsumeTime.new(account_id: params[:account_id], minutes: params[:minutes].to_i, activity_id: params[:activity_id])
    command_bus.(cmd)
	end
end
