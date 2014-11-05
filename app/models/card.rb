#encoding: utf-8
require "model-base"
class Card# 名片
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id       , Serial 
    property :pic_url  , Text   , :required => true, :unique => true
    # user's cards中的index
    property :index    , String , :required => true
    # 别名
    property :alias    , String
    # 用户对名片录入的评分
    property :score    , String # 用户可以输入文字
    # 名片图片是否合格
    property :is_ok    , Boolean
    # 名片图片不合格原因
    property :reason   , Text

    belongs_to :user  , :required => false
    belongs_to :carder, :required => false

    # hook
    after :create do |obj|
      action_logger(obj, "create", obj.to_params)
    end

    # instance methods
    def human_name
      "名片"
    end
end
