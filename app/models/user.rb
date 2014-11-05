#encoding: utf-8
require "model-base"
class User
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
    property :expired_at, DateTime, :default => DateTime.now
    property :paid_at   , String  
    property :op        , String  # order#1 or package#1

    has n, :campaigns

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
      "用户"
    end
end
