#encoding: utf-8
require "model-base"
class User
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id  , Serial 
    property :uid , String, :required => true, :unique => true

    has n, :cards   # 名片
    # 录入名片的转家
    has n, :carders, :through => :cards 

    def admin?
      @is_admin ||= Settings.admins.split(/;/).include?(self.email)
    end

    after :create do |obj|
      action_logger(obj, "create", obj.to_params)
    end
    # instance methods
    def human_name
      "微信用户"
    end
end
