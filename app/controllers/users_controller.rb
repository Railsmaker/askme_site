class UsersController < ApplicationController

  before_action :load_user, except:[:index, :create, :new]
  before_action :authorize_user, except:[:index, :new, :create, :show]

  def index
    @users = User.all
    @hashtags = Hashtag.all
  end

  def new
    redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?
    @user = User.new
  end

  def edit
    # появился фильтр # @user = User.find params[:id]
  end

  def show
    # появился фильтр # @user = User.find params[:id]   user_path(user)
    @questions = @user.questions.order(created_at: :desc)
    @new_question = @user.questions.build

    # счётчик вопросов
    @questions_count = @questions.count

    # логика .not, где answers не nil
    @answers_count = @questions.where.not(answer: nil).count
    # неотвеченные вопросы
    @unanswered_count = @questions_count - @answers_count
  end

  def create
    redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?
    @user = User.new(user_params)
    if @user.save
      # создание сессии
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Пользователь создан!'
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params) && @user == current_user
      redirect_to user_path(@user), notice: 'Данные обновлены'
    else
      render 'edit'
    end
  end

  def destroy
    if @user == current_user
      session[:user_id] = nil
      redirect_to root_path, notice: "Акаунт #{@user.name} удален!" if @user.destroy!
    else
      redirect_to users_path, notice: "Удалить не удалось, жмите на кнопку сильней !"
    end
  end

  private

  def authorize_user
    reject_user unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :username, :avatar_url,  :color)
  end

  def load_user
    redirect_to root_path unless @user ||= User.find_by(id: params[:id])
  end

end