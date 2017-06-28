class OrdersController < ApplicationController
  
  def create
    @account = Account.find(order_params[:account_id])
    @order = @account.orders.build(order_params)
    @inventory = @account.inventories.find_by(code: order_params[:code].upcase)
    order_price = @order.price.to_f * @order.volume.to_f
    
    @security = Security.find_by(code: order_params[:code].upcase)
    unless @security
      Security.create!(code: order_params[:code], market: "HKEX")
    end
    
    unless @inventory
      @account.inventories.build!(code: order_params[:code], volume: 0,
                                  activated_volume:0, total_cost: 0.0,
                                  security_id: @security.id)
    end
    
    if @order.order_type == "buy"
      if @account.cash >= order_price
        if @order.save && @account.update_attribute(:cash, @account.cash - order_price)
          flash[:info] = "Order has been made successfully!"
        end
      else
        flash[:info] = "Your account's cash is not enough!"
      end
    else
      if @inventory.activated_volume >= @order.volume.to_f
        if @order.save && @inventory.update_attribute(:activated_volume, @inventory.activated_volume - @order.volume.to_f)
          flash[:info] = "Order has been made successfully!"
        end
      else
        flash[:info] = "Your account's inventory does not hold enough securities!"
      end
    end
    @order.update_columns(total_cost: order_price, security_id: @security.id)
    redirect_to @account
  end
  
  def execute
    @order = Order.find(params["id"])
    @order.update_columns(executed: true, executed_at: Time.zone.now)
    @inventory = @account.inventories.find_by(code: @order.code)
    if @order.order_type == "buy"
      @inventory.update_columns(volume: @inventory.volume + @order.volume, total_cost: @inventory.total_cost + @order.total_cost)
    else
      @inventory.update_columns(volume: @inventory.volume - @order.volume, total_cost: @inventory.total_cost - @order.total_cost)
    end
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
