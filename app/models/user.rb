﻿#encoding: utf-8
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

    has n, :card_transfers
    has n, :cards, :through => :card_transfers
    #has n, :weixiners, :through => :cards

    after :create do |obj|
      # name default from email
      update(name: email.split(/@/).first) if name.nil? 
    end

    def admin?
      @is_admin ||= Settings.admins.split(/;/).include?(self.email)
    end

    # instance methods
    def human_name
      "名片转家"
    end
end
