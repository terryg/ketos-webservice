require "rubygems"

require "pg"
require "dm-core"
require "dm-types"
require "dm-validations"
require "dm-migrations"
require "dm-timestamps"

require "./user"
require "./post"

DataMapper.setup(:default, (ENV['HEROKU_POSTGRESQL_BLUE_URL'] || "postgres://localhost:5432/ketos_development"))
DataMapper.auto_upgrade!

