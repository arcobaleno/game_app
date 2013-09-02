class RedeemCreditsController < ApplicationController

	def index
		@credits = Credit.search(params[:search])
		if @credits.exists?
		@credit_redeemed = @credits.first
		@credit_redeemed.user_id = current_user.id
		@credit_redeemed.save
		flash[:success] = "Credit Redeemed"
		redirect_to current_user
		else
		flash[:error] = "Credit code invalid"
		redirect_to current_user	
		end
	end

end