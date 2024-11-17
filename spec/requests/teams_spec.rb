
require 'rails_helper'

RSpec.describe 'Teams API', type: :request do
  let(:owner) { create(:user) }
  let(:non_owner) { create(:user) }
  let(:team) { create(:team, owner: owner) }
  let(:headers) { { 'Authorization' => "Bearer #{owner.jwt_token}" } }
  let(:valid_params) { { name: 'Team Alpha', description: 'Top secret team', owner_id: owner.id } }

  describe 'POST /teams' do
    context 'when the request is valid' do
      it 'creates a new team' do
        post '/teams', params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq('Team Alpha')
      end
    end

    context 'when the request is invalid' do
      it 'returns a validation error' do
        post '/teams', params: { name: '' }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
      end
    end
  end

  describe 'Unauthorized access' do
    it 'prevents non-owners from deleting a team' do
      delete "/teams/#{team.id}", headers: { 'Authorization' => "Bearer #{non_owner.jwt_token}" }
      expect(response).to have_http_status(:forbidden)
      expect(JSON.parse(response.body)['message']).to eq('You are not authorized to perform this action')
    end
  end

  describe 'PUT /teams/:id' do
    context 'when the user is not the owner' do
      it 'does not allow updates' do
        put "/teams/#{team.id}", params: { name: 'New Name' }, headers: { 'Authorization' => "Bearer #{non_owner.jwt_token}" }
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['message']).to eq('You are not authorized to perform this action')
      end
    end
  
    context 'when the user is the owner' do
      it 'allows updates' do
        put "/teams/#{team.id}", params: { name: 'Updated Team' }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['name']).to eq('Updated Team')
      end
    end
  end
  
  
end

