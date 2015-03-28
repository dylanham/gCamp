class Private::PivotalProjectsController < PrivateController

  def show
    tracker_api = TrackerAPI.new
    if current_user.pivotal_tracker_token
      @tracker_projects = tracker_api.stories(current_user.pivotal_tracker_token, params[:id])
    end
  end
end
