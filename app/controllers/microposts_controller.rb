class MicropostsController < ApplicationController

	def index
		@microposts = Micropost.paginate(page: params[:page]).includes(:user)
	end

	def new
		@micropost = Micropost.new
	end

	def create
		@game = Game.find(params[:game_id])
		@pool = Pool.find(params[:pool_id])
		@micropost = Micropost.new(params[:micropost])
		if @micropost.save
			flash[:success] = "Micropost Created"
			redirect_to game_pool_path(@game,@pool)
		else
			flash[:error] = "Micropost not created, please try again!"
			redirect_to root_path
		end
	end

	def show
		@micropost = Micropost.find(params[:id])
		@user = User.find(params[:id])
	end

	def destroy
		Micropost.find(params[:id]).destroy
		flash[:success] = "Micropost Deleted"
		redirect_to root_path
	end

end