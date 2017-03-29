class UsersController < ApplicationController
  
  def new
    @user = User.new
    @edu_option = User.edu_option
    @gender_option = User.gender_option
    @marital_option = User.marital_option
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      flash[:success] = "Welcome to SecuSim!"
      redirect_to @user
    else
      @edu_option = User.edu_option
      @gender_option = User.gender_option
      @marital_option = User.marital_option
      render 'new'
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,:password_confirmation,
                                   :address, :gender, :education, :marital,
                                   :nationality, :bank, :bankaddress,
                                   :bankaccount, :tel)
    end
end
