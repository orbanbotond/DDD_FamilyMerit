class TransactionsController < ApplicationController
	def index
		@transactions = Fullfillment::Transaction.all
	end
end
