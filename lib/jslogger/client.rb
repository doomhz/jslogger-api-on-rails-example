require "rest_client"

module Jslogger
  class Client
    HOST = "http://jslogger.com"
    
    def initialize token = Jslogger::JSLOGGER_CLIENT_TOKEN, log_requests = Jslogger::JSLOGGER_CLIENT_LOG_REQUESTS
      @token = token
      @log_requests = log_requests
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
      params[:token] = @token
      request_data = {
        :params => params
      }
      response = RestClient.send(type, url, request_data)
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