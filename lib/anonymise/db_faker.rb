# frozen_string_literal: true

require 'faker'
require 'colorize'
require 'anonymise/db_connection'
module Anonymise
  class DbFaker
    include Anonymise::DbConnection
    attr_reader :config, :db_args
    def initialize(db_args, config)
      @db_args = db_args
      @config = config
    end

    def fake
      config.each do |table, columns|
        if t_ables.include?(table)
          puts "Anonymising table #{table}".colorize(:green)
          columns.each do |column, type|
            if column_exists?(table, column)
              available_data = connection.exec("select * from #{table}")
              available_data.each do |record|
                val = Faker::Alphanumeric.unique.alpha(number: 6)

                val = val.gsub(/[^a-z ]/, '')

                val = Faker::Internet.unique.email if type == 'email'
                val = Faker::Internet.unique.url if type == 'url'
                val = Faker::PhoneNumber.unique.cell if type == 'mobile'
                if type == 'number'
                  val = Faker::Faker::Number.unique.number(digits: 6)
                end
                connection.exec("UPDATE #{table} SET #{column}='#{val}' WHERE id='#{record['id']}'")
              end
            else
              puts "Column #{column} does not exist in #{table}_table".colorize(:red)
            end
          end
        else
          puts "Table #{table} does not exist on #{db_args[:db]}".colorize(:red)
        end
      end

      connection&.close
    end
  end
end
