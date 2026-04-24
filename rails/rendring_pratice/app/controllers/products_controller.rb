class ProductsController < ApplicationController

  # GET /products
  def index
    @products = Product.all

    if @products.any?
      result = @products.map { |p| "#{p.name} - #{p.price}" }.join("\n")
      render plain: result
    else
      render plain: "No products found"
    end
  end

  # GET /products/:id
  def show
    product = Product.find_by(id: params[:id])

    if product
      render plain: "Product: #{product.name} - #{product.price}"
    else
      render plain: "Product not found"
    end
  end

  # POST /products
  def create
    product = Product.new(product_params)

    if product.save
      render plain: "Product created: #{product.name} - #{product.price}"
    else
      render plain: product.errors.full_messages.join(", ")
    end
  end

  private

  # Strong Parameters
  def product_params
    params.require(:product).permit(:name, :price)
  end

end