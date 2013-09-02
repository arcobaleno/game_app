class AddressesController < ApplicationController

	def index
		@addresses = Address.all

		# JSON
		# render json: @addresses
	end

	def show
		@address = Address.find(params[:id])

		# JSON
		# render json: @address
	end

	def new
		@address = Address.new

		# JSON
		# render json: @address
	end

	def create
		@address = current_user.addresses.build(params[:address])
		if @address.save
			flash[:success] = "Address Saved"
			redirect_to root_path
		else
			flash[:error] = "Address not Saved, Try Again"
			redirect_to root_path
		end

		# JSON
		# render json: @address
	end

	def edit
	end

	def update
	end

	def destroy
	end

end