module Ohdb
	class LocTask < Task

		include TaskClassMethods

		def start_message
			"Counting total lines of code in each month..."
		end

		def do_work(scm)
			start_date = (LocTask.most_recent_head || Commit.first).date
			Month.months_between(start_date, Time.now.utc).each do |mm|
				month = Month.find_by_date(mm)
				create_locs(scm, month.commit) unless month.commit == self.head
				yield month.commit
			end
		end

		def create_locs(scm, commit)
			Ohcount::ScratchDir.new do |dir|
				scm.export(dir, commit.token)
				source_file_list = Ohcount::SourceFileList.new(:paths => [dir])
				source_file_list.analyze(:language)
				commit.locs = source_file_list.loc_list.locs.collect do |loc|
					Loc.new(:language => loc.language, :filecount => loc.filecount, :code => loc.code, :comments => loc.comments, :blanks => loc.blanks)
				end
				commit.save!
			end
		end

	end
end
