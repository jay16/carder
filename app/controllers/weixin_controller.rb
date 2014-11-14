#encoding: utf-8 
require "lib/utils/weixin_robot.rb"
require "lib/utils/reply_robot.rb"
class WeixinController < ApplicationController
  register Sinatra::WeiXinRobot
  register Sinatra::ReplyRobot
  set :views, ENV["VIEW_PATH"] + "/weixin"

  configure do
    enable  :logging
    set     :weixin_token, "carder_go_home"
    set     :weixin_uri,   "%s/weixin" % Settings.domain
    set     :weixin_name,     Settings.weixin.name
    set     :weixin_desc,     Settings.weixin.desc
    set     :weixin_yaml,     "config/command.yaml"
  end

  # weixin authenticate
  # get /weixin
  get "/" do
    params[:echostr].to_s
  end

  # receive message
  post "/" do
    return if generate_signature != params[:signature]

    weixin = message_receiver(request.body)
    _params = weixin.instance_variables.inject({}) do |hash, var|
      hash.merge!({var.to_s.sub(/@/,"") => weixin.instance_variable_get(var)})
    end
    _params[:from_user_name] = _params.delete("user")
    _params[:to_user_name]   = _params.delete("robot")

    weixiner = Weixiner.first_or_create(uid: _params[:from_user_name])
    message = weixiner.messages.new(_params)
    message.save_with_logger
    _response = reply_robot(message)
    message.update(response: _response)

    weixin.sender(msg_type: "text") do |msg|
      msg.content = _response
      msg.to_xml
    end
  end
end
