class MembersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_team
    before_action :authorize_owner!, only: [:create, :destroy]

  
    def index
      @members = @team.members
    end

    def show
        @member = Member.find(params[:id])
    end
  
    def create
      @member = @team.members.build(member_params)
      if @member.save
        redirect_to team_members_path(@team), notice: 'Member added successfully.'
      else
        render :index
      end
    end
  
    def destroy
      @member = @team.members.find(params[:id])
      @member.destroy
      redirect_to team_members_path(@team), notice: 'Member removed successfully.'
    end
  
    private
  
    def set_team
      @team = Team.find(params[:team_id])
    end
  
    def member_params
      params.require(:member).permit(:first_name, :last_name, :email)
    end
  end
  