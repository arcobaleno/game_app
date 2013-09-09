class CreditsController < ApplicationController
	helper_method :sort_column, :sort_direction

	def index
		@credits = Credit.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])
	end

	def new
		if banker?
			@credit = Credit.new
		else
			redirect_to permission_path
		end
	end

	def create
		@credit = Credit.new(params[:credit])
		@credit.random
		if @credit.save
			flash[:success] = "Credit Created!"
			redirect_to credits_path
		else
			flash[:error] = "Credit Not Created!"
			redirect_to credits_path
		end
	end

	def edit
		@credit = Credit.find(params[:id])
	end

	def update
		@credit = Credit.find(params[:id])
		if @credit.update_attributes(params[:credit])
			flash[:success] = "Credit info Updated!"
			render 'edit'
		else
			flash[:notice] = "Credit info not Updated!"
			render 'edit'
		end
	end

	def show
		@credit = Credit.find(params[:id])
		@owner = User.find_by_id(@credit.user_id)
	end

	def destroy
		Credit.find(params[:id]).destroy
    	flash[:success] = "Credit Deleted!"
    	redirect_to credits_path
	end

	# Custom Actions

	def transfer
	    if check_credits?(params[:amount].to_i)
	    	Credit.transfer_credits_banker_to_vendor(User.find(params[:id]),User.bankers.first,params[:amount])
		    flash[:success] = "transfer should work"
		    redirect_to show_banker_users_path
		else
			flash[:notice] = "banker has not enough credits to transfer"
			redirect_to show_banker_users_path
		end
 	end

	def payout
		@player = Player.find_by_id(params[:id])
		@pool = Pool.find_by_id(@player.pool_id)
		@game = Game.find_by_id(@pool.game_id)

		if 	check_credits?(@pool.buy_in)
			Credit.transfer_pool_credits_to_user(@pool,@player,params[:amount])
			flash[:success] = "Credit Paid Out"
			redirect_to game_pool_path(@game,@pool)
		else
			flash[:notice] = "Credit not Paid Out"
			redirect_to game_pool_path(@game,@pool)
		end
	end

	def redeem_credits
		@credit = Credit.search(params[:search])
		if @credit.exists?
		Credit.transfer_vendor_credits_to_user(@credit,current_user)
		flash[:success] = "Credit Redeemed"
		redirect_to current_user
		else
		flash[:error] = "Credit code invalid"
		redirect_to current_user	
		end

		# JSON
		# render json: {credits: @credits, credit_redeemed: @credit_redeemed}
	end

	private

	def sort_column
		params[:sort] || "id"
	end

	def sort_direction
		params[:direction] || "asc"
	end
end