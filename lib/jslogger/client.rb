require "rest_client"

module Jslogger
  class Client
    HOST = "http://jslogger.com"
    
    def initialize email = Jslogger::JSLOGGER_CLIENT_EMAIL, password = Jslogger::JSLOGGER_CLIENT_PASSWORD, log_requests = Jslogger::JSLOGGER_CLIENT_LOG_REQUESTS
      @email = email
      @password = password
      @log_requests = log_requests
    end
    
    def login cookies = nil
      if cookies
        return @cookies = cookies
      end
      log "Logging in", ""
      response = RestClient.post("#{HOST}/login", :email => @email, :password => @password)
      log "Log in code", response.code
      log "Log in response", response
      log "Log in cookies", response.cookies
      if response.code == 200
        return @cookies = response.cookies
      end
      nil
    end

    def stats
      get_response "get", "#{HOST}/manage/stats.json", {}
    end

    def errors
      get_response "get", "#{HOST}/manage/summaries.json", {:type => "log"}
    end

    def events
      get_response "get", "#{HOST}/manage/summaries.json", {:type => "event"}
    end

    def log_details log_id
      get_response "get", "#{HOST}/manage/summary.json/#{log_id}", {}
    end


    private

    def get_response type = "get", url, params
      log "Endpoint", url
      log "Request", params
      request_data = {
        :params => params
      }
      request_data[:cookies] = @cookies
      response = RestClient.send(type, url, request_data){ |response, request, result, &block|
        if [301, 302, 307].include? response.code
          response.follow_redirection(request, result, &block)
        elsif [401].include? response.code
          return 401
        else
          response.return!(request, result, &block)
        end
      }
      log "Response", response
      ActiveSupport::JSON.decode response
    end

    def log name, data
      if @log_requests
        begin
          Rails.logger.info "[JSLogger Client] #{name}: #{data}"
        rescue
        end
      end
    end
  end
end