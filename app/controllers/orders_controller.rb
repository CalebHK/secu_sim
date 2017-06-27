class OrdersController < ApplicationController
  
  def create
    @account = Account.find(order_params[:account_id])
    @order = @account.orders.build(order_params)
    if @order.order_type == "buy"
      order_price = @order.price.to_f * @order.volume.to_f
      if @account.cash >= order_price
        if @order.save && @account.update_attribute(:cash, @account.cash - order_price)
          flash[:info] = "Order has been made successfully!"
        end
      else
        flash[:info] = "Your account's cash is not enough!"
      end
    else
      @inventory = @account.inventories.find_by(code: order_params[:code])
      if @inventory.activated_volume >= @order.volume.to_f
        if @order.save && @inventory.update_attribute(:activated_volume, @inventory.activated_volume - @order.volume.to_f)
          flash[:info] = "Order has been made successfully!"
        end
      else
        flash[:info] = "Your account's inventory does not hold enough securities!"
      end
    end
    redirect_to @account
  end
  
  def cancel
    @order = Order.find(params[:id])
    @account = @order.account
    if @order.order_type == "buy"
      order_price = @order.price.to_f * @order.volume.to_f
      if @order.update_attributes(order_params) && @account.update_attribute(:cash, @account.cash + order_price)
        flash[:success] = "Order Cancelled!"
      end
    else
      @inventory = @account.inventories.where("code = ?", @order.code).first
      if @order.update_attributes(order_params) && @inventory.update_attribute(:activated_volume, @inventory.activated_volume + @order.volume.to_f)
        flash[:success] = "Order Cancelled!"
      end
    end
    redirect_to @order.account
  end
  
  private

    def order_params
      params.require(:order).permit(:code, :price, :volume, :order_type, :account_id)
    end
end
