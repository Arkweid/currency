# frozen_string_literal: true

ActiveAdmin.register ForceRate do
  menu false

  permit_params %i[rate expired_at]

  after_action do
    flash[:errors] = resource.errors.full_messages.to_sentence if resource.errors.any?
  end

  controller do
    def create
      create! { |format| format.html { redirect_to admin_dashboard_path } }
    end

    def update
      update! { |format| format.html { redirect_to admin_dashboard_path } }
    end
  end
end
