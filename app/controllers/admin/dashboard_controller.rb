module Admin
  class DashboardController < ApplicationController
    def index
      @talkers_without_schedule    = Talker.without_schedule
      @talkers_waiting_for_session = Talker.waiting_for_session
    end
  end
end
