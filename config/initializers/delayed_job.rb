
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 0.1
Delayed::Worker.max_attempts = 10
Delayed::Worker.max_priority = 10

Delayed::Worker.logger = Rails.logger

Delayed::Worker.logger.auto_flushing = 1