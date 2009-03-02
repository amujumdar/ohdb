module Ohdb
	class LocTask < MonthlyTask

		include TaskClassMethods

		def start_message
			"Counting total lines of code in each month..."
		end

		def do_commit(scm, commit)
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
