class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def create
    outcome = Forms::User::Create.run(params[:forms_user_create])
    if outcome.valid?
      redirect_to user_tr_path(outcome.result)
    else
      render :new
    end
  end

  def new
    @user_update_form = Forms::User::Create.new
  end

  def edit
    user = find_user!
    @user_update_form = Forms::User::Update.new user: user
  end

  def show
    @user = find_user!
  end

  def update
    inputs = { user: find_user! }
    inputs.reverse_merge! params[:forms_update_user]
    outcome = Forms::User::Update.run(inputs)
    if outcome.valid?
      redirect_to user_tr_path(outcome.result)
    else
      render :edit
    end
  end

  def destroy
    Operations::User::Destroy.run(user: find_user!)
    redirect_to :index
  end

  def entrance
    @user_login_form = Forms::User::Login.new
  end

  def login
    outcome = Forms::User::Login.run(params[:forms_login_user])
    if outcome.valid?
      redirect_to root_tr_path
    else
      render :entrance
    end
  end

  def registration
    @user_register_form = Forms::User::Register.new
  end

  def register
    outcome = Forms::User::Register.run(params[:forms_register_user])
    if outcome.valid?
      flash[:success] = t('user.register_successfull')
      redirect_to users_login_tr_path
    else
      render :registration
    end
  end

  private

  def find_user!
    outcome = Operations::User::Find.run(params)
    if outcome.valid?
      outcome.result
    else
      fail ActiveRecord::RecordNotFound,
           outcome.errors.full_messages.to_sentence
    end
  end

end
