module Ohdb::Commands
	class Activity < Base
		def run
			connect_db

			label, select = case options.group_by.to_s.downcase
			when 'l','language'
				['language', 'language']
			when 'n','name'
				['name','commits.name']
			when 'y','year'
				['month',"strftime('%Y', commits.date)"]
			when 'm','month'
				['month',"date(commits.date, 'start of month')"]
			end

			rows = ActiveRecord::Base.connection.select_all <<-SQL
			select
			#{ select ? select+' as '+label+',' : ''}
			count(distinct(commit_id)) as commits,
			sum(code_added) as code_added,
			sum(code_removed) as code_removed,
			sum(comments_added) as comments_added,
			sum(comments_removed) as comments_removed,
			sum(blanks_added) as blanks_added,
			sum(blanks_removed) as blanks_removed
			from loc_deltas
			inner join commits on loc_deltas.commit_id = commits.id
			#{ select ? 'group by '+select+' order by '+select : '' }
			SQL

			write_header(label)
			rows.each { |r| write_row(label, r) }
		end

		def write_header(label)
			puts
			puts "Total Activity#{ label ? ' By ' + label.capitalize : ''}".center(100)
			puts
			puts "-------------------------  -------  ------- Code -------  ----- Comments -----  ------ Blanks ------"
			puts "#{label.to_s.capitalize.ljust(25)}  Commits      Added    Removed      Added    Removed      Added    Removed"
			puts "-------------------------  -------  ---------  ---------  ---------  ---------  ---------  ---------"
		end


		def write_row(label, r)
			puts "#{(label ? r[label] : 'Total').ljust(25)}#{r['commits'].rjust(9)}#{r['code_added'].rjust(11)}#{r['code_removed'].rjust(11)}#{r['comments_added'].rjust(11)}#{r['comments_removed'].rjust(11)}#{r['blanks_added'].rjust(11)}#{r['blanks_removed'].rjust(11)}"
		end
	end
end
