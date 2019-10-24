module BookingSync::API
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :timeout

    def initialize
      @timeout = 20
    end
  end
  
  configure
end
