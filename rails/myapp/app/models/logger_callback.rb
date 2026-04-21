class LoggerCallback
  def self.before_save(record)
    puts "Logging from Callback Object"
  end
end