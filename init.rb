require "rubygems"

require "pg"
require "dm-core"
require "dm-types"
require "dm-validations"
require "dm-migrations"
require "oauth"
require "omniauth"
require "omniauth-twitter"
require "omniauth-tumblr"

require "./user"

DataMapper.setup(:default, (ENV['HEROKU_POSTGRESQL_BRONZE_URL'] || "postgres://localhost:5432/ketos_development"))
DataMapper.auto_upgrade!

