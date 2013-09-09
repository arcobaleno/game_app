class PrizesController < ApplicationController

	def index
		@available_prizes = Prize.prizes_available
		@redeemed_prizes = Prize.prizes_redeemed

		# JSON
		# render json: {prizes_available: @prizes_available, prizes_redeemed: @prizes_redeemed}
	end

	def new
		if admin?
			@prize = Prize.new
		else
			redirect_to permission_path
		end
	end

	def create
		@prize = current_user.prizes.build(params[:prize])
		if @prize.save
			flash[:success] = "Prize Added"
			redirect_to prizes_path
		else
			flash[:error] = "Prize not Added"
			redirect_to prizes_path
		end
	end

	def show
		@prize = Prize.find_by_id(params[:id])

		# JSON
		# render json: @prize
	end

	def redeem_prize
		@prize = Prize.find_by_id(params[:id])
		if check_credits?(@prize.value)
			if Credit.transfer_user_credits_to_banker(current_user, @prize.value)
				Prize.redeem_prize_for(current_user, @prize)
				flash[:success] = "Prize Redeemed!"
				redirect_to prizes_path
			else
				flash[:error] = "Prize not Redeemed!"
				redirect_to prizes_path
			end
		else
			flash[:error] = "Sorry you do not have any credits"
			redirect_to prizes_path
		end

		# JSON
		# render json: {credits: @credits, credit: @credit, banker: @banker, prize: @prize}
	end

	def edit
		@prize = Prize.find(params[:id])
	end

	def update
		@prize = Prize.find(params[:id])
		if @prize.update_attributes(params[:prize])
			flash[:success] = "Prize info Updated!"
			redirect_to prizes_path
		else
			flash[:notice] = "Prize info not Updated!"
			render 'edit'
		end
	end

	def destroy
	end

end