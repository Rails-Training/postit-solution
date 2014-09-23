class CategoriesController < ApplicationController
  before_action :set_category, only:[:show,:edit,:update]
  before_action :require_user, except: [:index, :show ]
  before_action :require_admin, except: [:index, :show]
  
  def index
    @categories = Category.all
  end
  
  def show
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(check_params);
    if @category.save
      flash[:notice] = "Category saved..."
      redirect_to categories_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @category.update(check_params)
      flash[:notice] = "Category updated..."
      redirect_to categories_path
    else
      render :edit
    end
  end
  
  private 
  def check_params
    params.require(:category).permit(:name)
  end
  
  private
  def set_category
    @category = Category.find_by(slug: params[:id]);  
  end
  
end