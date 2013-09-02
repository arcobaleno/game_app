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
		@credit = Credit.find_by_credit_code(@credit_code)
		@credit.user_id = current_user.user_id
		if @credit.update_attributes(params[:credit])
	        flash[:success] = "Credit Info Updated!"
	        redirect_to root_path
	    else
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
	    @user = User.find(params[:id])
	    @bankers = User.find_all_by_user_type(3)
	    @banker = @bankers.first
	    @banker_credits = Credit.find_all_by_user_id(@banker)
	    @credit = @banker_credits.first
	    if check_credits?
		    @credit.user_id = @user.id
		    @credit.save
		    flash[:success] = "transfer should work"
		    redirect_to show_banker_users_path
		else
			flash[:notice] = "banker has no credits to transfer"
			redirect_to show_banker_users_path
		end
 	end

	def payout
		@player = Player.find_by_id(params[:id])
		@pool = Pool.find_by_id(@player.pool_id)
		@game = Game.find_by_id(@pool.game_id)
		@credits = Credit.find_all_by_pool_id(@pool)
		@pay_one_credit = @credits.first
		@pay_one_credit.user_id = @player.user_id
		@pay_one_credit.pool_id = nil
		if @pay_one_credit.save
			@player.destroy
			flash[:success] = "Credit Paid Out"
			redirect_to game_pool_path(@game,@pool)
		else
			flash[:notice] = "Credit not Paid Out"
			redirect_to game_pool_path(@game,@pool)
		end
	end

	def redeem_credits
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