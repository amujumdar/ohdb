module Ohdb
	class Database
		attr_accessor :filename

		def initialize(filename = File.join(OHDB_ROOT, "db/#{OHDB_ENV}.sqlite3"))
			@filename = filename
		end

		def dbconfig
			{:adapter => 'sqlite3', :database => filename}
		end

		def establish_connection
			ActiveRecord::Base.establish_connection(dbconfig) unless ActiveRecord::Base.connected?
		end

		def migrate(version=nil)
			establish_connection
			ActiveRecord::Migrator.migrate(File.join(OHDB_ROOT, 'db/migrate'), version)
		end
	end
end
