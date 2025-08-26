class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]

    # GET /categories or /categories.json
  def index
    authorize! :read, Category
    @categories = current_user.categories
    
    # Filtro de busca por nome/descrição
    if params[:query].present?
      @categories = @categories.where("categories.name ILIKE ? OR categories.description ILIKE ?", 
                                      "%#{params[:query]}%", "%#{params[:query]}%")
    end
    
    # Filtro adicional por descrição se fornecido separadamente
    if params[:description].present?
      @categories = @categories.where("categories.description ILIKE ?", "%#{params[:description]}%")
    end
    
    # JOIN com expenses e incomes para obter contagem de uso
    @categories = @categories
      .left_joins(:expenses, :incomes)
      .select("categories.*, 
               COUNT(DISTINCT expenses.id) as expenses_count,
               COUNT(DISTINCT incomes.id) as incomes_count,
               (COUNT(DISTINCT expenses.id) + COUNT(DISTINCT incomes.id)) as total_usage")
      .group("categories.id")
    
    # Ordenação
    case params[:sort_by]
    when 'name'
      @categories = @categories.order('categories.name ASC')
    when 'usage_count'
      @categories = @categories.order('total_usage DESC, categories.name ASC')
    when 'created_at'
      @categories = @categories.order('categories.created_at DESC')
    else
      @categories = @categories.order('categories.name ASC')
    end
    
    # Calcular estatísticas antes da paginação
    all_categories = current_user.categories.joins("LEFT JOIN expenses ON expenses.category_id = categories.id LEFT JOIN incomes ON incomes.category_id = categories.id")
    @total_categories = current_user.categories.count
    @income_categories = current_user.categories.joins(:incomes).distinct.count
    @expense_categories = current_user.categories.joins(:expenses).distinct.count
    
    # Aplicar paginação por último
    @categories = @categories.page(params[:page])
  rescue => e
    Rails.logger.error "Erro na busca de categorias: #{e.message}"
    @categories = current_user.categories.none.page(params[:page])
    @total_categories = 0
    @income_categories = 0 
    @expense_categories = 0
    flash.now[:alert] = "Erro na busca. Tente novamente."
  end

  # GET /categories/1 or /categories/1.json
  def show
    authorize! :read, @category
  end

  # GET /categories/new
  def new
    @category = current_user.categories.build
    authorize! :create, @category
  end

  # GET /categories/1/edit
  def edit
    authorize! :update, @category
  end

  # POST /categories or /categories.json
  def create
    @category = current_user.categories.build(category_params)
    authorize! :create, @category

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    authorize! :update, @category
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: "Category was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    authorize! :destroy, @category
    @category.destroy!

    respond_to do |format|
      format.html { redirect_to categories_path, notice: "Category was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = current_user.categories.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.expect(category: [ :name, :description, :color, :category_type ])
    end
end

