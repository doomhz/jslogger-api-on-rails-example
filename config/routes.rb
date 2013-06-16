JsloggerApiOnRailsExample::Application.routes.draw do
  get "errors", :controller => "home", :action => "errors"
  get "events", :controller => "home", :action => "events"
  get "log/:id", :controller => "home", :action => "log"
  root :to => "home#index"
end
