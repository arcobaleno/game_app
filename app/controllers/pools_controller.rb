class PoolsController < ApplicationController

	def index
		@pools = Pool.paginate(page: params[:page])

		# JSON
		# render json: @pools
	end

	def new
		@game = Game.find_by_id(params[:game_id], :include => [{ :pools => :user }])
		@pool = Pool.new

		# JSON
		# render json: {game: @game, pool: @pool}
	end

	def show
		@pool = Pool.find_by_id(params[:id])
		@game = Game.find_by_id(params[:game_id], :include => [{ :pools => :user }])
		@player = Player.new
		@players = Player.find_all_by_pool_id(params[:id])
		@pool_credits = Credit.find_all_by_pool_id(@pool).count

		# JSON
		# render json: {pool: @pool, game: @game, player: @player, players: @players, pool_credits: @pool_credits}
	end

	def create
		@game = Game.find_by_id(params[:game_id])
		@pool = @game.pools.build(params[:pool])
		if @pool.save
			flash[:success] = "Pool Created!"
			redirect_to game_pool_path(@game,@pool)
		else
			flash[:error] = "Pool not Created, Try Again."
			redirect_to new_game_pool_path
		end

		# JSON
		#render json: {game: @game, pool: @pool}
	end

	def edit
	end

	def update
	end

	def destroy
	end
	
end