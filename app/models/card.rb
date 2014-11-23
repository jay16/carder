#encoding: utf-8
require "model-base"
class Card # 微信消息类型为image#名片
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model

    property :id       , Serial 
    property :pic_url  , Text   , :required => true#, :unique => true
    # user's cards中的index
    property :index    , Integer 
    # 别名
    property :alias    , String
    # 用户对名片录入的评分
    property :score    , String # 用户可以输入文字
    # 是否录入完成
    property :is_over  , Boolean, :default => false
    # 名片图片是否合格
    property :is_ok    , Boolean
    # 名片图片不合格原因
    property :reason   , Text

    has 1, :card_transfer
    belongs_to :message, :required => false


    # instance methods
    def human_name
      "名片#图片"
    end
   # class << self
   #   [:all, :get, :first, :last].each do |name|
   #     with_method    = "%s_with_print_sql" % name.to_s
   #     without_method = "%s_without_print_sql" % name.to_s
   #     alias_method without_method, name
   #     define_method "%s_with_print_sql" % name do |options|
   #       _t = Time.now.to_f
   #       _collection = self.send(without_method, options)
   #       _sql = ::DataMapper.repository.adapter
   #         .send(:select_statement,_collection.query).join(" ")
   #       puts "%s Load (%dms) %s" % [self.name, ((Time.now.to_f - _t)*1000).to_i, _sql]
   #       return _collection
   #     end
   #     alias_method name, with_method
   #   end
   # end
  # class << self 
  #   [:all, :get, :first, :last].each do |method|
  #     alias_method_chain method, :print_sql
  #   end
  # end
end
