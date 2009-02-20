module Ohdb
	class Database
		attr_accessor :filename

		def initialize(filename = File.join(OHDB_ROOT, "db/#{OHDB_ENV}.sqlite3"))
			# We remove any existing connection. This prevents re-using any
			# database we might already be connected to.
			ActiveRecord::Base.remove_connection
			@filename = filename
		end

		def dbconfig
			{:adapter => 'sqlite3', :dbfile => filename}
		end

		def establish_connection
			ActiveRecord::Base.establish_connection(dbconfig) unless ActiveRecord::Base.connected?
			ActiveRecord::Base.default_timezone = :utc
		end

		def migrate(version=nil)
			establish_connection
			ActiveRecord::Migrator.migrate(File.join(OHDB_ROOT, 'db/migrate'), version)
		end
	end
end
