class SettingsController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check

  def index
    @user = current_user
  rescue => e
    Rails.logger.error "Settings error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    redirect_to root_path, alert: "Erro ao carregar configurações: #{e.message}"
  end

  def update
    @user = current_user
    
    # Preparar parâmetros de atualização
    update_params = user_params
    update_params.delete(:current_password)
    password_change = params[:user][:password].present? && params[:user][:password].strip.length > 0
    
    # Se uma nova senha foi fornecida, verificar se a senha atual está correta
    if password_change
      unless @user.valid_password?(params[:user][:current_password])
        @user.errors.add(:current_password, "está incorreta")
        render :index, status: :unprocessable_entity
        return
      end
      # Usar update normal com validação de senha
      success = @user.update(update_params)
    else
      # Se senha não foi fornecida, usar update_without_password
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
      success = @user.update_without_password(update_params)
    end
    
    if success
      # Re-autenticar o usuário se a senha foi alterada
      sign_in(@user, bypass: true) if password_change
      redirect_to settings_path, notice: "Informações atualizadas com sucesso!"
    else
      render :index, status: :unprocessable_entity
    end
  end

  def reset_finances
    begin
      current_user.incomes.destroy_all
      current_user.expenses.destroy_all
      current_user.categories.destroy_all
      
      redirect_to settings_path, notice: "Todos os dados financeiros foram resetados com sucesso!"
    rescue => e
      redirect_to settings_path, alert: "Erro ao resetar dados: #{e.message}"
    end
  end

  def destroy_account
    begin
      user = current_user
      sign_out(user)
      user.destroy!
      
      redirect_to root_path, notice: "Sua conta foi excluída permanentemente."
    rescue => e
      redirect_to settings_path, alert: "Erro ao excluir conta: #{e.message}"
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :current_password)
  end
end
