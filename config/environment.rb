require 'bundler'
require 'rainbow'

Bundler.require

PROMPT = TTY::Prompt.new
Rainbow.enabled = true

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

ActiveRecord::Base.logger = nil

