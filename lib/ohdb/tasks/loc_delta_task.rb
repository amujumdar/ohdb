module Ohdb
	class LocDeltaTask < Task

		include TaskClassMethods

		def start_message
			"Counting lines of code changed in each commit..."
		end

		def do_work(scm)
			scm.each_commit(self.head && self.head.token) do |scm_commit|
				c = Commit.find_by_token(scm_commit.token)
				lds = calculate_loc_deltas(scm, scm_commit)
				insert_loc_deltas(c, lds)
				yield c
			end
		end

		def calculate_loc_deltas(scm, scm_commit)
			filenames = scm.ls_tree(scm_commit.token)

			scm_commit.diffs.inject(Ohcount::LocDeltaList.new) do |total, diff|
				before = Ohcount::SourceFile.new(diff.path, :contents => scm.cat_file_parent(scm_commit, diff), :filenames => filenames)
				after = Ohcount::SourceFile.new(diff.path, :contents => scm.cat_file(scm_commit, diff), :filenames => filenames)

				total + before.diff(after)
			end
		end

		def insert_loc_deltas(commit, scm_loc_delta_list)
			scm_loc_delta_list.loc_deltas.each do |scm_loc_delta|
				db_loc_delta = LocDelta.find_by_commit_id_and_language(commit.id, scm_loc_delta.language) ||
					commit.loc_deltas.build(:language => scm_loc_delta.language)

				db_loc_delta.code_added       = scm_loc_delta.code_added
				db_loc_delta.code_removed     = scm_loc_delta.code_removed
				db_loc_delta.comments_added   = scm_loc_delta.comments_added
				db_loc_delta.comments_removed = scm_loc_delta.comments_removed
				db_loc_delta.blanks_added     = scm_loc_delta.blanks_added
				db_loc_delta.blanks_removed   = scm_loc_delta.blanks_removed

				db_loc_delta.save!
			end
		end

	end
end
