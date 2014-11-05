#encoding: utf-8
require "model-base"
class Weixin
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model

    property :id             , Serial 
    property :msg_type       , String  , :required => true
    property :msg_id         , String  , :required => true
    property :raw_message    , Text    , :required => true
    property :robot          , String  , :required => true
    property :user           , String  , :required => true
    property :create_time    , String  , :required => true
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

    # instance methods
    def human_name
      "微信消息"
    end
end
