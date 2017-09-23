class TeamsController < ApplicationController
  before_action :set_by_slug_team, only: [:show]
  before_action :set_team, only: [:destroy]

  def index
  end

  def show
    authorize! :read, @team
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to "/#{@team.slug}"
    else
      redirect_to main_app.root_url, notice: @team.errors
    end
  end

  def destroy
    authorize! :destroy, @team
    @team.destroy
  end

  private

  def set_by_slug_team
    @team = Team.find_by(slug: params[:slug])
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:slug).merge(user: current_user)
  end
end
