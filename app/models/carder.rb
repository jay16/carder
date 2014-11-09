#encoding: utf-8
require "model-base"
class Carder
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id        , Serial 
    property :email     , String  , :required => true, :unique => true
    property :name      , String
    property :password  , String  , :required => true
    property :gender    , Boolean 
    property :country   , String  
    property :province  , String  
    property :city      , String  

    has n, :cards
    has n, :users, :through => :cards

    def admin?
      @is_admin ||= Settings.admins.split(/;/).include?(self.email)
    end

    after :create do |obj|
      action_logger(obj, "create", obj.to_params)
      # name default from email
      if name.nil? 
        update(name: email.split(/@/).first)
      end
    end
    # instance methods
    def human_name
      "名片转家"
    end
end
