class IncomesController < ApplicationController
  before_action :set_income, only: %i[ show edit update destroy ]

  # GET /incomes or /incomes.json
  def index
    authorize! :read, Income
    @incomes = current_user.incomes.includes(:category)
    
    # Filtros de busca
    @incomes = @incomes.where("incomes.description ILIKE ?", "%#{params[:query]}%") if params[:query].present?
    @incomes = @incomes.where(category_id: params[:category_id]) if params[:category_id].present?
    @incomes = @incomes.where("incomes.amount >= ?", params[:min_amount]) if params[:min_amount].present?
    @incomes = @incomes.where("incomes.amount <= ?", params[:max_amount]) if params[:max_amount].present?
    @incomes = @incomes.where("incomes.date >= ?", params[:date_from]) if params[:date_from].present?
    @incomes = @incomes.where("incomes.date <= ?", params[:date_to]) if params[:date_to].present?
    
    # Ordenação
    case params[:sort_by]
    when 'amount_asc'
      @incomes = @incomes.order('incomes.amount')
    when 'amount_desc'
      @incomes = @incomes.order('incomes.amount DESC')
    when 'date_asc'
      @incomes = @incomes.order('incomes.date')
    when 'date_desc'
      @incomes = @incomes.order('incomes.date DESC')
    when 'description'
      @incomes = @incomes.order('incomes.description')
    else
      @incomes = @incomes.order('incomes.date DESC')
    end
    
    # Dados para os filtros - sempre inicializar
    @categories = current_user.categories.order(:name)
    
    # Calcular total filtrado antes da paginação
    @total_filtered = @incomes.sum(:amount) || 0
    
    # Aplicar paginação por último
    @incomes = @incomes.page(params[:page])
  rescue => e
    Rails.logger.error "Erro na busca de receitas: #{e.message}"
    @incomes = current_user.incomes.none.page(params[:page])
    @categories = current_user.categories.order(:name)
    @total_filtered = 0
    flash.now[:alert] = "Erro na busca. Tente novamente."
  end

  # GET /incomes/1 or /incomes/1.json
  def show
    authorize! :read, @income
  end

  # GET /incomes/new
  def new
    @income = current_user.incomes.build
    @income.category_id = params[:category_id] if params[:category_id].present?
    authorize! :create, @income
  end

  # GET /incomes/1/edit
  def edit
    authorize! :update, @income
  end

  # POST /incomes or /incomes.json
  def create
    @income = current_user.incomes.build(income_params)
    authorize! :create, @income

    respond_to do |format|
      if @income.save
        format.html { redirect_to @income, notice: "Income was successfully created." }
        format.json { render :show, status: :created, location: @income }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incomes/1 or /incomes/1.json
  def update
    authorize! :update, @income
    respond_to do |format|
      if @income.update(income_params)
        format.html { redirect_to @income, notice: "Income was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @income }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incomes/1 or /incomes/1.json
  def destroy
    authorize! :destroy, @income
    @income.destroy!

    respond_to do |format|
      format.html { redirect_to incomes_path, notice: "Income was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income
      @income = current_user.incomes.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def income_params
      params.expect(income: [ :category_id, :amount, :date, :description, :receipt_file, :receipt ])
    end
end

