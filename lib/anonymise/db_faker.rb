# frozen_string_literal: true

require 'faker'
require 'pg'
require 'colorize'
module Anonymise
  class DbFaker
    def initialize(db_args, path)
      @db_args = db_args
      @path = path
    end

    def fake
      tables.each do |table|
        next if excluded_tables.include?(table['table_name'])

        puts "Anonymising #{table['table_name']}_table".colorize(:green)
        columns.each do |key, values|
          values.each do |column|
            next unless column_exists?(table['table_name'], column)

            available_data = connection.exec("select * from #{table['table_name']}")
            available_data.each do |record|
              klass_data = Object.const_get("Faker::#{key.capitalize}").send(column.to_sym)

              unless column == 'email'
                klass_data = klass_data.gsub(/[^a-z ]/, '')
              end
              connection.exec("UPDATE #{table['table_name']} SET #{column}='#{klass_data}' WHERE id='#{record['id']}'")
            end
          end
        end
      end
      connection&.close
    end

    private

    def connection
      @connection ||= PG.connect @db_args
    rescue PG::Error => e
      puts e.message.colorize(:red)
    end

    def columns
      @columns ||= if configured_columns.nil?
                     {
                       name: %w[
                         first_name
                         last_name
                         name
                       ],
                       internet: %w[
                         email
                         url
                       ]
                     }
                   else
                     configured_columns
                   end
    end

    def configured_columns
      @configured_columns ||= if !@path.nil? && File.exist?(@path)
                                YAML.safe_load(File.open(@path))
                              else
                                []
                              end
    end

    def tables
      @tables ||= connection.exec "SELECT table_name FROM information_schema.tables
        WHERE table_schema = 'public'"
    end

    def excluded_tables
      @excluded_tables ||= %w[schema_migrations ar_internal_metadata]
    end

    def column_exists?(table, column)
      res = connection.exec('SELECT TRUE FROM pg_attribute WHERE attrelid = (SELECT c.oid
    FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = CURRENT_SCHEMA() AND c.relname =\''"#{table}"'\')
    AND attname = \''"#{column}"'\' AND NOT attisdropped AND attnum > 0')
      records_count = res.count
      records_count.positive?
    end
  end
end
