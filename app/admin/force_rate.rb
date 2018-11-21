ActiveAdmin.register ForceRate do
  menu false

  permit_params %i(rate expired_at)

  controller do
    def create
      create! do |format|
        flash[:errors] = resource.errors.full_messages.to_sentence if resource.errors.any?
        format.html { redirect_to admin_dashboard_path }
      end
    end

    def update
      update! do |format|
        flash[:errors] = resource.errors.full_messages.to_sentence if resource.errors.any?
        format.html { redirect_to admin_dashboard_path }
      end
    end
  end
end
