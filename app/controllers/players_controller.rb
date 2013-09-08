class PlayersController < ApplicationController

	def index
		@players = Player.find_all_by_pool_id(params[:pool_id])
		# JSON
		# render json: @players
	end

	def new
	end

	def show
		@player = Player.find_by_id(params[:id])
		@pool = Pool.find_by_id(params[:pool_id])
		@game = Game.find_by_id(params[:game_id], :include => [{ :pools => :user }])

		# JSON
		# render json: {player: @player, pool: @pool, game: @game}
	end

	def create
		@game = Game.find(params[:game_id])
		@pool = Pool.find_by_id(params[:pool_id])

		@player = @pool.players.build(params[:player])

		@player.user_id = current_user.id
		@player.bet = @pool.buy_in

		if check_credits?(@pool.buy_in)
			if @player.save
				Credit.transfer_user_credits_to_pool(current_user, @pool, @pool.buy_in)
				flash[:success] = "You are now a member of this pool"
				redirect_to game_pool_path(@game,@pool)
			else
				flash[:notice] = "Sorry you were unable to join the pool"
				render 'static_pages/home' #this will change
			end
		else
			flash[:notice] = "Sorry Not enough credits to join this pool"
			redirect_to game_pool_path(@game,@pool)
		end
	end

	def edit
	end

	def update
	end

	def destroy
		@player = Player.find_by_id(params[:id])
		if @player.destroy
			flash[:notice] = "Player destroyed"
		else
			flash[:error] = "Sorry Player not destroyed"
		end
	end

end