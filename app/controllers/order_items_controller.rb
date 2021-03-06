class OrderItemsController < ApplicationController
    def index
        @order_items = OrderItem.all 
        render json: @order_items
    end

#example
    # def index
    
    #     @carts = current_user.carts
    
    #     render json: @carts
    #   end


    def show
        @order_item = OrderItem.find_by(params[:id])
        render json: @order_item
    end

    def create
        @order_item = OrderItem.new(order_item_params)
        if @order_item.save
             render json: @order_item
        else
            render json: @order_item.errors
        end
    end

    def update
        @order_item = OrderItem.find(params[:id])
        @order_item.update(order_item_params)
        render json: @order_item
    end

    def destroy
        @order_item = OrderItem.find(params[:id])
        @order_item.destroy
        render json: { message: 'success'}
    end

    private

    def order_item_params
        params.require(:order_item).permit(:user_id, :score_id)
    end
   
end
