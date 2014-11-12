#encoding: utf-8 
class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"

  # root page
  get "/" do
    redirect "/carder" if current_user

    haml :index, layout: :"../layouts/layout"
  end

  # redirect to cpanel
  get "/admin" do
    redirect "/carder"
  end

  # redirect
  # login
  get "/login" do
    redirect "/carder/user/login"
  end
  # register
  get "/register" do
    redirect "/carder/user/register"
  end
end
