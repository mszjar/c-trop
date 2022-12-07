class DashboardController < ApplicationController
  skip_after_action :verify_authorized

  def show
    @markets = policy_scope(Market)
    @markets = current_user.markets
    @nb_markets = current_user.markets.count

    @markers = @markets.geocoded.map do |market|
      if market.ping_gris == true
        image = "ping-gris.svg"
        color = "gray"
      elsif market.total_price < MarketProduct.average_price
        image = "ping-vert.svg"
        color = "green"
      else
        image = "ping-rouge.svg"
        color = "red"
      end
      {
        lat: market.latitude,
        lng: market.longitude,
        info_window: render_to_string(partial: "info_window", locals: { market: market }),
        image_url: helpers.asset_url(image),
        total_price: market.total_price.round(2),
        color: color,
        pourcentage: ((market.price_level * 100) - 100).round(2)
      }
    end
    @user_marker = helpers.asset_url("ping.png")
  end
end
