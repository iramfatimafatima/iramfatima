class TeamsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_team
    before_action :authorize_owner!, only: [:edit, :update, :destroy]
  
    def index
        @users = User.all
      @teams = current_user.owned_teams
    end
  
    def show
        @team = Team.find(params[:id])
        @members = @team.members.includes(:user) # Preload users to avoid N+1 queries
        @users = User.all
    end

    
  
    def new
     @users = User.all
      @team = Team.new
    end
  
    
    def create
        @team = current_user.owned_teams.build(team_params)
        if @team.save
          # Add selected members to the team
          debugger
          params[:members].each do |member_id|
            debugger
            # @team.members.create(user_id: member_id)
            Member.create(team_id: @team.id, user_id: member_id)  
          end
          redirect_to @team, notice: 'Team created successfully.'
        else
          render :new
        end
      end



    def edit
        @team = Team.find(params[:id]) 
        @users = User.all 
    end


    def search_members
        
        @members = if params[:last_name].present?
                     @team.users.where("last_name LIKE ?", "%#{params[:last_name]}%")
                   else
                     @team.users
                   end
                   redirect_to @team
      end

  
    def update
      if @team.update(team_params)
        redirect_to @team, notice: 'Team updated successfully.'
      else
        render :edit
      end
    end
  
    def destroy
      @team.destroy
      redirect_to teams_path, notice: 'Team deleted successfully.'
    end

    def add_member
        @team = Team.find_by(id: params[:id])
      
        # Check if team is found
        if @team.nil?
          redirect_to teams_path, alert: "Team not found"
          return
        end
      
        # You might want to check if the user exists and handle this case as well
        @user = User.find_by(id: params[:user_id])
      
        if @user.nil?
          redirect_to @team, alert: "User not found"
          return
        end
      
        # If team and user are valid, add the member
        if @team.owner == current_user || @team.owner == @user
          # Add user to the team
          @team.members.create(user_id: @user.id)
          redirect_to @team, notice: "Member added successfully."
        else
          redirect_to @team, alert: "You are not authorized to add members."
        end
      end
      
      def remove_member
        debugger
        member = @team.members.find(params[:member_id])
        if member.destroy
          flash[:notice] = "Member removed successfully."
        else
          flash[:alert] = "Unable to remove member."
        end
        redirect_to team_path(@team)
      end
    
      
    
  
    private
  
    def set_team
      @team = Team.find(params[:id])
    end
  
    def team_params
      params.require(:team).permit(:name, :description, :owner_id, members: [])
    end
  
    def authorize_owner!
      redirect_to teams_path, alert: 'Not authorized' unless @team.owner == current_user
    end
  end
  