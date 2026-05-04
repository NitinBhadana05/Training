class PostJob
  include Sidekiq::Job

  def perform(post_id)
    Rails.logger.info("Processing post #{post_id}")
  end
end
