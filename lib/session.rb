class Session
  class << self
    def init(session)
      @session = session
    end

    def data
      @session
    end

    def get(key)
      @session[key]
    end
  end
end