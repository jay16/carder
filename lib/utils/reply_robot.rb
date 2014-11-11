#encoding: utf-8
require "yaml"
require "erb"

module Sinatra
  module ReplyRobot 
    # command instance methods
    module InstanceMethods
      def load_yaml(file_path)
        file_contents = File.read(file_path)
        YAML.load(ERB.new(file_contents).result).to_hash
      end
    end
    # only for command
    module CommandInstanceMethods
      # TODO get function name in it's scope
      # ca
      def cmd_alias(options)
      end
      # cq
      def cmd_query(options)
        command, index, rest = options
        card = Card.first(index: index)
        result = ["录入状态: %s完成." % (card.is_over ? "" : "未")]
        result.push "录入时间: %s" % card.created_at.strftime("%Y-%m-%d %H:%M")
        result.join("\n")
      end
      # cl
      def cmd_list(options)
      end
      # ci = query index
      def cmd_index(options)
      end
      # cs
      def cmd_store(options)
      end
      # cf
      def cmd_feedback(options)
      end
      # cu
      def cmd_usage(options)
      end
      # ch
      def cmd_help(options)
      end
    end
    # command parser
    class Command 
      include InstanceMethods
      include CommandInstanceMethods
      attr_reader :key, :command, :raw_cmd, :exec_cmd
      def initialize(raw_cmd, yaml)
        @result   = []
        @raw_cmd  = raw_cmd
        @commands = yaml["command"]
      end
      def self.exec(raw_cmd, yaml)
        reply = new(raw_cmd, yaml)
        reply.handler
      end
      def handler
        @response = find_key ? parse : help
        result = []
        result.push "输入命令:\n %s" % @raw_cmd
        if @exec_cmd
          result.push "执行命令:\n %s" % @exec_cmd 
        else
          result.push "命令解析失败!"
        end
        result.push @response
        result.join("\n")
      end
      # whether command exist in yaml
      def find_key
        @key = @commands.keys.find do |key|
          regexp = @commands[key]["regexp"]
          Regexp.new(regexp) =~ @raw_cmd
        end
      end
      # parse command when @key exist
      def parse
         regexp = @commands[@key]["regexp"]
         Regexp.new(regexp) =~ @raw_cmd
         @exec_cmd = $&
         send(:cmd_query, @exec_cmd.split)
      end
      # help menu
      def help
        @commands.keys.map do |key|
          "c%s %s" % [key, @commands[key]["human"]]
        end.join("\n")
      end
    end # Command

    class Parser
      include InstanceMethods
      def initialize(message, weixin_yaml)
        @message     = message
        @weixin_yaml = weixin_yaml
        @yaml        = load_yaml(@weixin_yaml)
        @msg_type_hash = {
          "text"     => "文本",
          "image"    => "图片",
          "link"     => "链接",
          "video"    => "视频",
          "voice"    => "音频",
          "location" => "位置",
          "event"    => "事件"
        }
      end

      def handler
        "消息类型:[%s]\n" % @msg_type_hash[@message.msg_type] + 
        case @message.msg_type
        when "text"  then Command.exec(@message.content, @yaml)
        when "image" then "%s\n名片ID: %s\n" % [@yaml["image"], @message.card.index]
        when "event" then @yaml["event"][@message.event]
        else "类型为[%s],暂不支持!" % @message.msg_type
        end
      end

      def self.exec(message, weixin_yaml)
        parser = new(message, weixin_yaml)
        parser.handler
      end
    end

    module ReplyHelpers
      def reply_robot(message)
        Sinatra::ReplyRobot::Parser.exec(message, settings.weixin_yaml)
      end
    end

    def self.registered(robot)
      robot.set     :weixin_name,     "NAME"
      robot.set     :weixin_desc,     "DESC"
      robot.set     :weixin_yaml,     "DESC"
      robot.helpers  ReplyHelpers
    end
  end # ReplyRobot
  register ReplyRobot
end