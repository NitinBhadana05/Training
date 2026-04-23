class ProductsController < ApplicationController
  def show
    @product = Product.first || Product.create(name: "Laptop", price: 50000, stock:10)
  end
end