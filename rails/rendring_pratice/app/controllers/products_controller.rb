class ProductsController < ApplicationController

  before_action :require_login
  before_action :check_admin, only: [:create]

  
  # GET /products
  def index
    @products = Product.all

    if @products.any?
      result = @products.map { |p| "#{p.name} - #{p.price}" }.join("\n")
      render "products/index"
    else
      render plain: "No products found"
    end

    #message = flash[:notice] || flash[:alert]

    #if message
    #  render plain: "Message: #{message}"
    #else
    #  render plain: "No message"
    #end
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
  #def create
  #  product = Product.new(product_params)
#
  #  if product.save
  #    render plain: "Product created successfully: #{product.name} - #{product.price}"
  #  else
  #    render plain: product.errors.full_messages.join(", ")
  #  end
  #end

  def create
      product = Product.new(product_params)

      if product.save
        flash[:notice] = "Product created successfully"
        redirect_to products_path
      else
        flash[:alert] = product.errors.full_messages.join(", ")
        redirect_to products_path
      end
  end

  def expensive
    price = params[:price].to_i

    products = Product.where("price > ?", price)

    if products.any?
      result = products.map { |p| "#{p.name} - #{p.price}" }.join("\n")
      render plain: result
    else
      render plain: "No expensive products found"
    end
  end


  private

  # Strong Parameters
  def product_params
    params.require(:product).permit(:name, :price)
  end

end