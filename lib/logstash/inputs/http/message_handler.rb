# encoding: utf-8
require "logstash-input-http_jars"

module LogStash module Inputs class Http
  class MessageHandler
    include org.logstash.plugins.inputs.http.IMessageHandler

    attr_reader :input

    def initialize(input, default_codec, additional_codecs, auth_token)
      @input = input
      @default_codec = default_codec
      @additional_codecs = additional_codecs
      @auth_token = auth_token
    end

    def validates_token(token)
      if @auth_token
        @auth_token == token
      else
        true
      end
    end

    def requires_token
      !!@auth_token
    end

    def onNewMessage(remote_address, headers, body)
      @input.decode_body(headers, remote_address, body, @default_codec, @additional_codecs)
    end

    def copy
      MessageHandler.new(@input, @default_codec.clone, clone_additional_codecs(), @auth_token)
    end

    def clone_additional_codecs
      clone_additional_codecs = {}
      @additional_codecs.each do |content_type, codec|
        clone_additional_codecs[content_type] = codec.clone
      end
      clone_additional_codecs
    end

    def response_headers
      @input.response_headers
    end

  end
end; end; end
