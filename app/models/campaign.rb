#encoding: utf-8
require "model-base"
class Campaign # 活动
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id       , Serial 
    property :subject  , String , :required => true
    property :to       , String , :required => true # to
    property :tos      , Text   # when to out limit
    property :desc     , Text
    property :mid      , String , :unique => true # for api query, 
    property :type     , String , :default => "web"

    belongs_to :user, :required => false

    # hook
    after :create do |obj|
      action_logger(obj, "create", obj.to_params)
    end

    # instance methods
    def human_name
      "活动"
    end
end
