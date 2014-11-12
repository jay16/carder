#encoding: utf-8
require "model-base"
class TName # 名片信息中的名称
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id   , Serial 
    property :name , Text,    :required => true
    property :count, Integer, :default => 0

    # instance methods
    def human_name
      "名片#名称"
    end
end
