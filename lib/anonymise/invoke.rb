# frozen_string_literal: true

require 'anonymise/db_faker'
module Anonymise
  class Invoke < Thor::Group
    include Thor::Actions

    desc 'Anonymise DB'

    argument :opt, type: :hash, desc: 'Options'

    def db_name
      if opt['db'].nil?
        puts 'Database name to anonymise is required'.colorize(:red)
        exit
      end
      @db_name ||= opt['db']
    end

    def config
      if opt['path'].nil?
        puts 'Path to config file is required'.colorize(:red)
        exit
      end

      unless File.exist?(opt['path'])
        puts 'File does not exist'.colorize(:red)
        exit
      end
      @content = YAML.safe_load(File.open(opt['path']))

      if @content.empty?
        puts 'Config file is empty kindly check https://github.com/thirunjuguna/anonymise/blob/master/anonymise.yml'
        exit
      end

      @config ||= @content
    end

    def user
      @user ||= opt['user']
    end

    def password
      @password ||= opt['password']
    end

    def port
      @port ||= opt['port']
    end

    def host
      @host ||= opt['host']
    end

    def setup
      db_args = {
        dbname: @db_name,
        user: @user,
        password: @password,
        port: @port,
        host: @host
      }
      klass = Anonymise::DbFaker.new(db_args, config)
      klass.fake
    end
  end
end
