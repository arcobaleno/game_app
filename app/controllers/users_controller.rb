class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers, :show_banker, :show_vendor]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  before_filter :banker_user,    only: :show_banker
  before_filter :vendor_user,    only: :show_vendor
  helper_method :sort_column, :sort_direction

  def index
    if admin?
    @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])
    #Banker Function
    @vendors = User.vendors
    else
      redirect_to permission_path
    end
  end

  def new
    @user = User.new

  # JSON
  # render json: @user
  end
  

  def create
    @user = User.new(params[:user])
    if @user.save
       sign_in @user
       redirect_to @user
    else
       render 'new'
    end

    # JSON
    # render json: @user
  end

  def show
  	@user = User.find(params[:id])
    #User type 1: Credit Dashboard
    @player_credits = Credit.player_credits(current_user).count
    @pool_credits = Credit.pool_credits(current_user)
    #Pools feed that user is in
    @pool_items = current_user.players.paginate(page: params[:page])

    if banker?
      redirect_to show_banker_users_path
    end

    # JSON
    # render json: {user: @user, player_credits: @player_credits, pool_credits: @pool_credits, credit_code: @credit_code}
    # @credit_code = input
  end

  def edit
    @user = User.find(params[:id])

    # JSON
    # render json: @user
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
        sign_in @user
        flash[:success] = "User Profile updated"
        redirect_to @user
    else
        render 'edit'
    end

    # JSON
    # render json: @user
  end

  def destroy
    @user = User.find(params[:id])
    #Gives Credits back to bank when user is deleted
    Credit.transfer_user_credits_upon_destroy(@user, User.bankers.first)
    #Deletes User
    @user.destroy
    # MUST DESTROY ALL ASSOCIATED PLAYERS AS WELL
    flash[:success] = "User Deleted!"
    redirect_to users_path
  end

  #Banker Account Actions:
  def show_banker
    @user = User.find(current_user)
    @vendors = User.vendors
    #Dashboard
    @total_credits = Credit.all.count
    @all_credits_in_bank = Credit.all_credits_in(User.bankers).count #method
    @all_credits_in_vendors = Credit.all_credits_in(User.vendors).count #method
    @all_credits_in_players = Credit.all_credits_in(User.players).count #method
    @all_credits_in_pools = Credit.all_pool_credits.count #scope
  end
 
  #Vendor Account Actions:
  def show_vendor
     @user = User.find(current_user)
    #Show Credit Code to users
    if check_credits?(1)
      @credit = Credit.all_credits_in(current_user).first
    else
      flash[:notice] = "Vendor has no credits to offer"
      redirect_to @user
    end
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.user_type == 4
  end

  def banker_user
    redirect_to root_path unless current_user.user_type == 3
  end

  def vendor_user
    redirect_to root_path unless current_user.user_type == 2
  end

  def sort_column
    params[:sort] || "first_name"
  end

  def sort_direction
    params[:direction] || "asc"
  end
  
end