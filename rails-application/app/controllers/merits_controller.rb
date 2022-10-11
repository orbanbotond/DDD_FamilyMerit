class MeritsController < ApplicationController
	def index
	end

	def balances
		@user = User.first
		@balances = TimeHarvest::Report.all
	end

	def new
		@users = User.all
	end

	def create
    cmd = TimeHarvest::CreateAccount.new(user_id: params[:user_id], account_id: SecureRandom.hex(16))
    command_bus.(cmd)
	end
end
