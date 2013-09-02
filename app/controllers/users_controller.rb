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
    @vendors = User.find_all_by_user_type(2)
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
    @player_credits = Credit.find(:all, :conditions => {:user_id => current_user.id, :pool_id => nil}).count
    @players = current_user.players
    @pool_credits = @players.sum(:bet)
    @credit_code = Credit.find_by_credit_code(:credit_code)

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
    User.find(params[:id]).destroy
    flash[:success] = "User Deleted!"
    redirect_to users_path
  end

  #Banker Account Actions:
  def show_banker
    @user = User.find(current_user)
    @total_credits = Credit.all.count
    @bankers = User.find_all_by_user_type(3)
    @credits_in_bank = Credit.find_all_by_user_id(@bankers).count
    @vendors = User.find_all_by_user_type(2)
    @credits_in_vendors = Credit.find_all_by_user_id(@vendors).count
    @players = User.find_all_by_user_type(1)
    @credits_in_players = Credit.find_all_by_user_id(@players).count
    @credits_in_pools = Credit.find_all_by_user_id(nil).count
  end

  #Vendor Account Actions:
  def show_vendor
    @user = User.find(current_user)
    @vendor_credits = Credit.find_all_by_user_id(current_user)
    @vendor_credit_count = @vendor_credits.count
    @vendor_credit_first = @vendor_credits.first
    @credit_code = @vendor_credit_first.credit_code
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
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