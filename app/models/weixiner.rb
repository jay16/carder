#encoding: utf-8
require "model-base"
class Weixiner
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id  , Serial 
    # 微信名称
    property :uid,    String, :required => true, :unique => true
    property :status, String, :default => "subscribe"

    has n, :messages # 微信消息
    # 名片#微信消息类型为image
    has n, :cards, :through => :messages
    # 录入名片的转家
    #has n, :users, :through => :cards 

    def admin?
      @is_admin ||= Settings.admins.split(/;/).include?(self.email)
    end

    # instance methods
    def human_name
      "微信用户"
    end
end
