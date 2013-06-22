require "jslogger"

class HomeController < ApplicationController
  
  def index
    @stats = get_jslogger.stats
  end

  def errors
    @last_errors = get_jslogger.errors
  end

  def events
    @last_events = get_jslogger.events
  end

  def log
    @log = get_jslogger.log_details params[:id]
  end


  private

  def get_jslogger
    Jslogger::Client.new
  end
end
