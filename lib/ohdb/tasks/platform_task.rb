module Ohdb
	class PlatformTask < MonthlyTask

		include TaskClassMethods

		def start_message
			"Detecting platforms in each month..."
		end

		def do_commit(scm, commit)
			Ohcount::ScratchDir.new do |dir|
				scm.export(dir, commit.token)
				source_file_list = Ohcount::SourceFileList.new(:paths => [dir])
				source_file_list.analyze(:gestalt)
				commit.platforms = source_file_list.gestalt_facts.platforms.collect do |p|
					Platform.new(:name => p.to_s.split('::').last)
				end + source_file_list.gestalt_facts.tools.collect do |t|
					Platform.new(:name => t.to_s.split('::').last)
				end
				commit.save!
			end
		end

	end
end
