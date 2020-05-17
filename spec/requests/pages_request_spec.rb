require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /home' do
    it 'returns http success' do
      get '/pages/home'
      # expect(response).to have_http_status(:success)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
