module Ohdb::Commands
	class Activity < Base
		def run
			connect_db
			report = Ohdb::ActivityReport.new(options)
			rows = report.select_all
			write_header(report)
			rows.each { |r| write_row(report, r) }
		end

		def write_header(report)
			puts
			puts report.title.center(73 + report.columns.size * 27)
			puts "As of #{report.head.date.strftime('%Y-%m-%d %H:%M:%S')}Z".center(73 + report.columns.size * 27)
			puts

			report.columns.each do
				STDOUT.write "-------------------------  "
			end
			puts "-------  ------- Code -------  ----- Comments -----  ------ Blanks ------"

			report.columns.each do |col|
				STDOUT.write "#{col.to_s.capitalize.ljust(25)}  "
			end
			puts "Commits      Added    Removed      Added    Removed      Added    Removed"

			report.columns.each do
				STDOUT.write "-------------------------  "
			end
			puts "-------  ---------  ---------  ---------  ---------  ---------  ---------"
		end

		def write_row(report, r)
			report.columns.each do |col|
				STDOUT.write r[col].to_s.ljust(27)
			end
			STDOUT.write r['commits'].to_s.rjust(7)
			STDOUT.write r['code_added'].to_s.rjust(11)
			STDOUT.write r['code_removed'].to_s.rjust(11)
			STDOUT.write r['comments_added'].to_s.rjust(11)
			STDOUT.write r['comments_removed'].to_s.rjust(11)
			STDOUT.write r['blanks_added'].to_s.rjust(11)
			STDOUT.write r['blanks_removed'].to_s.rjust(11)
			puts
		end

	end
end
