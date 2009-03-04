module Ohdb
	class ActivityReport
		attr_accessor :group_by, :language, :name, :month, :year, :head

		def initialize(options=OpenStruct.new)
			@group_by = options.group_by
			@language = options.language
			@name = options.name
			@month = options.month
			@year = options.year
		end

		def rows
			@rows ||= select_all
		end

		def select_all
			@head = LocDeltaTask.most_recent_head
			rows = if @head
				ActiveRecord::Base.connection.select_all <<-SQL
					select #{ select_sql }
					count(distinct(commit_id)) as commits,
					sum(code_added) as code_added,
					sum(code_removed) as code_removed,
					sum(comments_added) as comments_added,
					sum(comments_removed) as comments_removed,
					sum(blanks_added) as blanks_added,
					sum(blanks_removed) as blanks_removed
					from loc_deltas
					inner join commits on loc_deltas.commit_id = commits.id
					#{ where_sql }
					and commits.position <= #{@head.position}
					#{ group_by_sql }
					#{ order_by_sql }
				SQL
			else
				[]
			end
			rows.each { |r| cast(r) }
			rows
		end

		def where_sql
			where = 'where (1=1) '
			if @month
				where << " and date(commits.date, 'start of month')=date(#{ActiveRecord::Base.connection.quote(@month)}, 'start of month')"
			end
			if @language
				where << " and language=#{ActiveRecord::Base.connection.quote(@language)}"
			end
			if @name
				where << " and name=#{ActiveRecord::Base.connection.quote(@name)}"
			end
			if @year
				where << " and strftime('%Y', commits.date)=#{ActiveRecord::Base.connection.quote(@year)}"
			end
			where
		end

		def select_sql
			if @group_by.any?
				group_sql_pairs.map { |label, sql| "#{sql} as #{label}," }.join
			else
				''
			end
		end

		def group_by_sql
			if @group_by.any?
				"group by " + group_sql_pairs.map{ |label, sql| sql }.join(',')
			else
				''
			end
		end

		def order_by_sql
			if @group_by.any?
				"order by " + group_sql_pairs.map{ |label, sql| sql }.join(',')
			else
				''
			end
		end

		def columns
			group_sql_pairs.map { |label, sql| label }
		end

		def group_sql_pairs
			@group_by.map do |g|
				case g.to_s.downcase
				when 'l','language'
					['language', 'language']
				when 'n','name'
					['name','commits.name']
				when 'y','year'
					['year',"strftime('%Y', commits.date)"]
				when 'm','month'
					['month',"date(commits.date, 'start of month')"]
				else
					raise ArgumentError.new("'#{g}' is not a valid group_by option")
				end
			end
		end

		def cast(row)
			['commits', 'code_added', 'code_removed', 'comments_added', 'comments_removed', 'blanks_added', 'blanks_removed'].each do |col|
				row[col] = row[col].to_i if row[col]
			end
		end

		def title
			t = "Activity"
			if @group_by.any?
				t << " By " + columns.map { |label| label.capitalize }.join(", ")
			end
			if @name
				t << ", Author Name='#{@name}'"
			end
			if @year
				t << ", Year='#{@year}'"
			end
			if @month
				t << ", Month='#{@month}'"
			end
			if @language
				t << ", Language='#{@language}'"
			end
			t
		end
	end
end
