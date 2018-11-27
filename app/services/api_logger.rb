# frozen_string_literal: true

module ApiLogger
  def log(error)
    logger.tagged(error.class) { logger.error(error.message) }
  end

  private

  def logger
    ActiveSupport::TaggedLogging.new(Logger.new(log_path))
  end

  def log_path
    raise NotImplementedError
  end
end
