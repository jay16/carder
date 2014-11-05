#encoding: utf-8 
require "lib/utils/weixin_robot.rb"
class WeixinController < ApplicationController
  register Sinatra::WeiXinRobot
  set :views, ENV["VIEW_PATH"] + "/weixin"

  configure do
    enable  :logging
    set     :weixin_token, "carder_go_home"
    set     :weixin_uri,   "http://carders.solife.us/weixin"
  end

  get "/" do
    "#{params[:echostr]}"
  end

  post "/" do
    if generate_signature == params[:signature]
      weixin = message_receiver(request.body)
      weixin.sender(:msg_type => "text") do |msg|
        msg.content = "Hello"
        msg.complete!
        msg.to_xml
      end
    end
  end
end
