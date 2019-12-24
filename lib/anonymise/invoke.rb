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
      path = opt['path']
      klass = Anonymise::DbFaker.new(db_args, path)
      klass.fake
    end
  end
end
