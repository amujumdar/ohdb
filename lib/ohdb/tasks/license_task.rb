module Ohdb
	class LicenseTask < MonthlyTask

		include TaskClassMethods

		def start_message
			"Detecting licenses in each month..."
		end

		def do_commit(scm, commit)
			Ohcount::ScratchDir.new do |dir|
				scm.export(dir, commit.token)
				source_file_list = Ohcount::SourceFileList.new(:paths => [dir])
				commit.licenses = []
				source_file_list.each_source_file do |s|
					commit.licenses += s.licenses.collect do |l|
						License.new(:name => l.to_s, :path => s.filename[(dir.length+1)..-1])
					end
				end
				commit.save!
			end
		end

	end
end
