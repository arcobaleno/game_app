class GamesController < ApplicationController

	def index
		@games = Game.paginate(page: params[:page])

		# JSON
		# render json: @games
	end

	def new
		if admin?
			@game = Game.new
		else
			redirect_to permission_path
		end
	end

	def show
		@game = Game.find_by_id(params[:id])

		# JSON
		# render json: @game
	end

	def create
		if admin?
			@game = current_user.games.build(params[:game])
			if @game.save
				flash[:success] = "Game created!"
				redirect_to games_path
			else
				flash[:notice] = "Game Not Created"
				redirect_to games_path
			end
		else
			redirect_to permission_path
		end
	end

	def edit
		if admin?
			@game = Game.find_by_id(params[:id])
		else
			redirect_to permission_path
		end
	end

	def update
		if admin?
			@game = Game.find_by_id(params[:id])
			if @game.update_attributes(params[:game])
	        	flash[:success] = "Game updated"
	        	redirect_to games_path
	    	else
	    		flash[:success] = "Sorry Game not updated"
	    		redirect_to games_path
			end
		else
			redirect_to permission_path
		end
	end

	def destroy
		@game.destroy
		redirect_to root_path
	end

end