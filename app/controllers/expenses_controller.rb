class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit update destroy ]

  # GET /expenses or /expenses.json
  def index
    authorize! :read, Expense
    @expenses = current_user.expenses.includes(:category)
    
    # Filtros de busca
    @expenses = @expenses.where("expenses.description ILIKE ?", "%#{params[:query]}%") if params[:query].present?
    @expenses = @expenses.where(category_id: params[:category_id]) if params[:category_id].present?
    @expenses = @expenses.where("expenses.amount >= ?", params[:min_amount]) if params[:min_amount].present?
    @expenses = @expenses.where("expenses.amount <= ?", params[:max_amount]) if params[:max_amount].present?
    @expenses = @expenses.where("expenses.date >= ?", params[:date_from]) if params[:date_from].present?
    @expenses = @expenses.where("expenses.date <= ?", params[:date_to]) if params[:date_to].present?
    
    # Ordenação
    case params[:sort_by]
    when 'amount_asc'
      @expenses = @expenses.order('expenses.amount')
    when 'amount_desc'
      @expenses = @expenses.order('expenses.amount DESC')
    when 'date_asc'
      @expenses = @expenses.order('expenses.date')
    when 'date_desc'
      @expenses = @expenses.order('expenses.date DESC')
    when 'description'
      @expenses = @expenses.order('expenses.description')
    else
      @expenses = @expenses.order('expenses.date DESC')
    end
    
    # Dados para os filtros - sempre inicializar
    @categories = current_user.categories.order(:name)
    
    # Calcular total filtrado antes da paginação
    @total_filtered = @expenses.sum(:amount) || 0
    
    # Aplicar paginação por último
    @expenses = @expenses.page(params[:page])
  rescue => e
    Rails.logger.error "Erro na busca de despesas: #{e.message}"
    @expenses = current_user.expenses.none.page(params[:page])
    @categories = current_user.categories.order(:name)
    @total_filtered = 0
    flash.now[:alert] = "Erro na busca. Tente novamente."
  end

  # GET /expenses/1 or /expenses/1.json
  def show
    authorize! :read, @expense
  end

  # GET /expenses/new
  def new
    @expense = current_user.expenses.build
    @expense.category_id = params[:category_id] if params[:category_id].present?
    authorize! :create, @expense
  end

  # GET /expenses/1/edit
  def edit
    authorize! :update, @expense
  end

  # POST /expenses or /expenses.json
  def create
    @expense = current_user.expenses.build(expense_params)
    authorize! :create, @expense

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    authorize! :update, @expense
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: "Expense was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    authorize! :destroy, @expense
    @expense.destroy!

    respond_to do |format|
      format.html { redirect_to expenses_path, notice: "Expense was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = current_user.expenses.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.expect(expense: [ :category_id, :amount, :date, :description, :receipt_file, :receipt ])
    end
end

