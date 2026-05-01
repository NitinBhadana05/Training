class ProductsController < ApplicationController

  def index
    @products = Rails.cache.fetch("products", expires_in: 10.minutes) do
      Product.all
    end
  end
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Product created successfully"
    else
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :photo)
  end
end