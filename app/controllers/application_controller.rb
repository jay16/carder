#encoding: utf-8
#require 'sinatra/advanced_routes'
require 'digest/md5'
require "json"
class ApplicationController < Sinatra::Base
  before do
    print_format_logger(params)
  end

  register Sinatra::Reloader
  register Sinatra::Flash
  # register Sinatra::AdvancedRoutes
  # register Sinatra::Auth

  helpers ApplicationHelper
  helpers TransactionsHelper
  helpers HomeHelper
  helpers Sinatra::FormHelpers
  
  enable :sessions, :logging, :dump_errors, :raise_errors, :static, :method_override

  # css/js/view配置文档
  use ImageHandler
  use SassHandler
  use CoffeeHandler
  use AssetHandler

  # global functions list
  def remote_ip
    request.ip 
  end
  def remote_path
    request.path 
  end
  def remote_browser
    request.user_agent
  end
  def run_shell(cmd)
    IO.popen(cmd) { |stdout| stdout.reject(&:empty?) }.unshift($?.exitstatus.zero?)
  end 
  # global function
  def uuid(str)
    str += Time.now.to_f.to_s
    md5_key(str)
  end
  def md5_key(str)
    Digest::MD5.hexdigest(str)
  end
  def sample_3_alpha
    (('a'..'z').to_a + ('A'..'Z').to_a).sample(3).join
  end
  def regexp_ppc_order
    @regexp_ppc_order ||= Regexp.new(Settings.regexp.order)
  end
  def regexp_ppc_order_item
    @regexp_ppc_order_item ||= Regexp.new(Settings.regexp.order_item)
  end

  def current_user
    @current_user ||= User.first(email: request.cookies["cookie_user_login_state"])
  end
  # action_logger
  # current_user
  include Utils::ActionLogger

  # filter
  def authenticate! 
    if request.cookies["cookie_user_login_state"].to_s.strip.empty?
      # 记录登陆前的path，登陆成功后返回至此path
      response.set_cookie "cookie_before_login_path", {:value=> request.url, :path => "/", :max_age => "2592000"}

      flash[:notice] = "继续操作前请登录."
      redirect "/user/login", 302
    end
  end

  # format gem#dm-validations errors info
  def format_dv_errors(model)
    errors = []
    model.errors.each_pair do |key, value|
      errors.push({ key => value })
    end
    return errors
  end

  def print_format_logger(params)
    hash = params || {}
    info = {:ip => remote_ip, :browser => remote_browser}
    if not hash.empty? 
      model = grep_params_model(hash)
      hash[model] = hash.fetch(model).merge(info) if model
    end
    params = hash.merge(info)
    puts %Q(\n\n%s "%s" for %s at %s) % [request.request_method, request.path, request.ip, Time.now.to_s]
    puts %Q(Parameters: %s\n\n) % params.to_s
  end

  def grep_params_model(hash)
    models  = %w[user package order track campaign]
    model = hash.inject([]) do |sum, _hash|
      key, value = _hash
      sum.push(key) if key and value.is_a?(Hash)
      sum
    end.uniq.first
    if model and models.include?(model)
      return model
    end
  end


  # 404 page
  not_found do
    haml :"shared/not_found", layout: :"layouts/layout", views: ENV["VIEW_PATH"]
  end
  #private
    def build_relation_with_items(order)
      JSON.parse("[%s]" % order.detail).each_with_index do |item, index|
        quantity = item.delete("quantity").to_i
        1.upto(quantity) do |i|
          item.merge!({ pre_paid_code: Time.now.to_f.to_s })
          order_item = order.order_items.new(item)
          if order_item.save
            pre_paid_code = "%s%du%do%di%s" % ["ppc", order.user_id, order.id, order_item.id, sample_3_alpha]
            order_item.update(:pre_paid_code => pre_paid_code)
          else
            puts "failed to save order_item: %s" % order_item.errors.inspect
          end
        end
      end
    end
end
