﻿#encoding: utf-8
require "model-base"
class Message # 微信消息
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model

    property :id             , Serial 
    property :msg_type       , String  , :required => true
    property :raw_message    , Text    , :required => true
    property :to_user_name   , String  , :required => true
    property :from_user_name , String  , :required => true
    # debug it without below two
    property :create_time    , String#  , :required => true
    property :msg_id         , String#  , :required => true
    # text
    property :content        , Text
    # image
    property :pic_url        , Text
    # location
    property :location_x     , String
    property :location_y     , String
    property :scale          , String
    property :label          , String
    # link
    property :title          , String
    property :description    , Text
    property :url            , Text
    # event
    property :event          , String
    property :latitude       , String
    property :precision      , String

    # 响应内容 - 自定义
    property :response       , Text

    has 1, :card
    belongs_to :weixiner, :required => false

    after :save do |message|
      # 名片ID#index, 相对user自增
      if message.msg_type == "image"
        # http://datamapper.org/docs/associations.html
        # normal usage:
        #   card = Card.new
        #   message.card = card
        #   message.save
        # but this block call in after :save
        # will loop without end
        card = Card.new({
          :message_id  => message.id,
          :pic_url     => message.pic_url,
          :index       => message.weixiner.cards.count + 1
        })
        card.save_with_logger
      end
    end

    # instance methods
    def human_name
      "微信消息"
    end
end
