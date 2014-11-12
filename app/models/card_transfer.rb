#encoding: utf-8
require "model-base"
class CardTransfer # 微信消息类型为image#名片
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id     , Serial 
    property :content, Text

    belongs_to :user,  :required => false
    belongs_to :card,  :required => false

    # instance methods
    def human_name
      "名片#通讯录"
    end
end
