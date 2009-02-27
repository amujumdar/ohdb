module Ohdb::Commands
	class Size < Base
		def run
			connect_db

			rows = ActiveRecord::Base.connection.select_all <<-SQL
			select date(months.date, 'start of month') as date,
			sum(code) as code,
			sum(comments) as comments,
			sum(blanks) as blanks
			from locs
			inner join months on months.commit_id = locs.commit_id
			inner join commits on commits.id = locs.commit_id
			group by date(months.date, 'start of month')
			SQL

			write_header
			rows.each { |r| write_row(r) }
		end

		def write_header
			puts
			puts "Total Lines of Code By Month".center(63)
			puts
			puts "Month            Code    Comment  Comment %      Blank      Total"
			puts "----------  ---------  ---------  ---------  ---------  ---------"
		end


		def write_row(r)
			code = r['code'].to_i
			comment = r['comments'].to_i
			blank = r['blanks'].to_i
			printf("%-10s", r['date'])
			printf(" %10d", code)
			printf(" %10d", comment)
			if comment+code > 0
				printf(" %9.1f%%", comment.to_f / (comment+code).to_f * 100.0)
			else
				printf("       0.0%");
			end
			printf(" %10d", blank)
			printf(" %10d\n", code+comment+blank)
		end
	end
end

