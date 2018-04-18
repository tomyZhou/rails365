class VisitController < ApplicationController
  def index
    authorize! :manage, :all
  end
end
