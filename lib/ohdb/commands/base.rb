module Ohdb::Commands
	class Base
		attr_accessor :options

		def initialize(options=OpenStruct.new)
			@options = options
		end

		def setup_logger
			ActiveRecord::Base.logger = Logger.new(File.open(@options.output + ".log", 'a'))
			Scm::Adapters::AbstractAdapter.logger = ActiveRecord::Base.logger
		end

		def connect_db
			unless FileTest.exist?(@options.output)
				puts "Database '#{@options.output}' not found."
				exit 1
			end
			setup_logger
			Ohdb::Database.establish_connection(@options.output)
		end

		def create_db
			FileUtils.mkdir_p(File.dirname(@options.output)) unless FileTest.directory?(File.dirname(@options.output))
			setup_logger

			unless FileTest.exist?(@options.output) || options.quiet
				puts "Creating database #{@options.output}"
			end
			Ohdb::Database.create(@options.output)
		end

		def scm
			return @scm if @scm
			@scm = Scm::Adapters::Factory.from_path(options.path)
			@scm.branch_name = options.branch_name if options.branch_name

			unless @scm && @scm.exists?
				STDERR.puts "Could not find a source control repository at path '#{options.path}'"
				exit 1
			end
			@scm
		end

		def run
		end
	end
end
