# frozen_string_literal: true

require 'rake'
require 'faker'
require 'pg'
require 'colorize'
require 'thor'
require 'thor/group'
require 'anonymise/invoke'
require 'anonymise/version'
module Anonymise
  class Command < Thor
    desc '-v', 'Show Anonymise version'
    map %w[-v --version] => :version

    def version
      say "Anonymise version #{Anonymise::VERSION}"
    end

    register Anonymise::Invoke, 'fake', 'fake db:db_name path:path_to_config_file', 'Anonymise Database'

    def self.exit_on_failure
      true
    end
  end
end
