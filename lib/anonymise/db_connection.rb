# frozen_string_literal: true

require 'pg'
require 'colorize'
module Anonymise
  module DbConnection
    def t_ables
      t_ables = connection.exec "SELECT table_name FROM information_schema.tables
        WHERE table_schema = 'public'"
      @t_ables ||= t_ables.map { |m| m['table_name'] }
    end

    def column_exists?(table, column)
      res = connection.exec('SELECT TRUE FROM pg_attribute WHERE attrelid = (SELECT c.oid
    FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = CURRENT_SCHEMA() AND c.relname =\''"#{table}"'\')
    AND attname = \''"#{column}"'\' AND NOT attisdropped AND attnum > 0')
      records_count = res.count
      records_count.positive?
    end

    def connection
      @connection ||= PG.connect db_args
    rescue PG::Error => e
      puts e.message.colorize(:red)
      exit
    end
  end
end
