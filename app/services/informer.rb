# frozen_string_literal: true

module Informer
  def warning(error)
    # TODO: Describe any way that you prefer to inform devs/admins
    # Rollbar.warning(error)
    # Telegram.warning(error)
    # Slack.warning(error)
  end
end
