# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET index' do
    it 'assigns @usd_rate' do
      get :index
      expect(assigns(:usd_rate)).to eq('66,7800')
    end
  end
end
