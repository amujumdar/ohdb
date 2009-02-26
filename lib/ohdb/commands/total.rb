module Ohdb::Commands
	class Total < Base
		def run
			connect_db

			puts
			puts "Total Activity By Language".center(90)
			puts
			puts "---------------   ------- Code --------   ------ Comments -----   ------ Blanks -------"                  
			puts "Language              Added     Removed      Added     Removed      Added     Removed"
			puts "---------------   ---------  ----------   ---------  ----------   ---------  ----------"

			rows = ActiveRecord::Base.connection.select_all <<-SQL
			select language,
			sum(code_added) as code_added,
			sum(code_removed) as code_removed,
			sum(comments_added) as comments_added,
			sum(comments_removed) as comments_removed,
			sum(blanks_added) as blanks_added,
			sum(blanks_removed) as blanks_removed
			from loc_deltas group by language order by language;
			SQL
			
			rows.each { |r| write_row r }
		end

		def write_row(r)
			puts "#{r['language'].ljust(15)}#{r['code_added'].rjust(12)}#{r['code_removed'].rjust(12)}#{r['comments_added'].rjust(12)}#{r['comments_removed'].rjust(12)}#{r['blanks_added'].rjust(12)}#{r['blanks_removed'].rjust(12)}"
		end
	end
end
