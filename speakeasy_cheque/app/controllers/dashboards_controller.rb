class DashboardsController < ApplicationController
  before_filter :authenticate_user

  def show
    get_aggregate_counts

    @users_per_day, @users_trending_up = Metric.users
    @messages_per_user, @messages_per_user_trending_up = Metric.messages

    time_period = params[:x_axis] || "week"
    @point_interval, @point_start = Chart::TimePeriod.send(time_period)

    @chart_title = Chart.title_for(params[:num], params[:denom])
    @series = Chart.series_for(params[:num], params[:denom], time_period)
  end

  private

  def get_aggregate_counts
    @total_users = Aggregate.users
    @total_messages = Aggregate.messages
    @total_rooms = Aggregate.rooms
  end

  def authenticate_user
    unless SpeakeasyBouncerGem.user_is_admin?(cookies['user'])
      render status: :unauthorized, text: "Looks like you're not on the list."
    end
  end
end
