module Ohdb
	class Database

		def self.create(filename)
			establish_connection(filename)
			migrate
		end

		def self.dbconfig(filename)
			{:adapter => 'sqlite3', :dbfile => filename, :timeout => 5000}
		end

		def self.establish_connection(filename)
			# We remove any existing connection. This prevents re-using any
			# database we might already be connected to.
			ActiveRecord::Base.remove_connection

			ActiveRecord::Base.establish_connection(dbconfig(filename))
			ActiveRecord::Base.default_timezone = :utc
			self
		end

		def self.migrate(version=nil)
			ActiveRecord::Migrator.migrate(File.join(OHDB_ROOT, 'db/migrate'), version)
		end
	end
end
