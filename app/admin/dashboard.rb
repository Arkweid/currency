ActiveAdmin.register_page 'Dashboard' do
  content title: proc { I18n.t('active_admin.dashboard.title') } do
    div class: 'blank_slate_container' do
      div class: 'force_rate_container' do
        render partial: 'admin/force_rate'
      end
    end
  end

  controller do
    before_action :set_resource

    def set_resource
      @resource = ForceRate.first_or_initialize
    end
  end
end
