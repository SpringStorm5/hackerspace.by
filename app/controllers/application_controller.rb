class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_if_hs_open if Rails.env.production?
  before_action :check_for_present_people if Rails.env.production?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def check_if_hs_open
    @event = Event.light.where('created_at >= ?', 30.minutes.ago).order(created_at: :desc).first

    @hs_open_status = if @event.nil?
                        Hspace::UNKNOWN
                      else
                        event_status
                      end
    # @hs_open_status = Hspace::OPENED
    # для отладки индикатора
  end

  def check_for_present_people
    d = Device.find_by(name: 'bob')
    @hs_present_people = d.events.where('created_at >= ?', 5.minutes.ago).map {|e| e.value}
    @hs_present_people.uniq!
  end

  private
  def event_status
    @event.value == 'on' ? Hspace::OPENED : Hspace::CLOSED
  end
end
