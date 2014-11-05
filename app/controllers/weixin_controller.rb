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

  # weixin authenticate
  # get /weixin
  get "/" do
    params[:echostr].to_s
  end

  post "/" do
    return if generate_signature != params[:signature]
    weixin = message_receiver(request.body)

    model_param = weixin.instance_variables.inject({}) do |hash, var|
      hash.merge!({var.to_s.sub(/@/,"") => weixin.instance_variable_get(var)})
    end
    model = Weixin.new(model_param)
    user  = User.first_or_create(:user => model.user)

    unless model.save
      model_param.merge!({"error" => format_dv_errors(model)})
      puts "\n\n %s \n\n" % model_param.to_s
    end

    puts model_param.to_s
    weixin.sender(:msg_type => "text") do |msg|
      msg.content = "get your %s msg!" % model.msg_type 
      msg.to_xml
    end
  end
end
