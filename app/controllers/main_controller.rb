class MainController < ApplicationController
  def index
  end

  def rules
  end

  def calendar
    @heatmap = Event.heatmap
  end

  def contacts
  end

  def spaceapi
    endpoint = SpaceAPIEndpoint.new
    if @hs_open_status != Hspace::UNKNOWN
      endpoint[:state][:open] = @hs_open_status == Hspace::OPENED
      endpoint[:state][:lastchange] = Event.order(updated_at: :desc).first.updated_at.to_i
      endpoint[:sensors][:people_now_present][0][:value] = @hs_present_people.count unless @hs_present_people.nil?
      endpoint[:sensors][:people_now_present][0][:names] = @hs_present_people unless @hs_present_people.nil?
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Cache-Control'] = 'no-cache'

    respond_to do |format|
      format.json { render json: endpoint }
    end
  end

  def webcam
    authenticate_user!

    @snapshots = WebcamSnapshot.find_all
    @current_snapshot = nil
    if !params[:snapshot].nil?
      @current_snapshot = @snapshots.find_index {|s| s.filename == params[:snapshot]}
    else
      @current_snapshot = @snapshots.size - 1 if !@snapshots.empty? and @snapshots.last.time >= Rails.application.config.webcam_timeout_mins.minutes.ago
    end
    logger.debug @snapshots.inspect
    logger.debug @current_snapshot.inspect

    respond_to do |format|
      format.html
    end
  end
end

