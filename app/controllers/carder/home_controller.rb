#encoding: utf-8 
class Carder::HomeController < Carder::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/carder/home"

  before do
    authenticate!
  end

  get "/" do
    @cards = current_user.cards

    haml :index, layout: :"../layouts/layout"
  end

end
