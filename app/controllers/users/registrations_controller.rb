class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  layout 'application'

  def edit
    super
  end

  def update
    super
  end

  def reset_finances
    current_user.incomes.destroy_all
    current_user.expenses.destroy_all
    
    redirect_to settings_path, notice: 'Histórico financeiro resetado com sucesso!'
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :current_password)
  end
end
