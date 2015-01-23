class AddNameIndexToDceLtiUsers < ActiveRecord::Migration
  def change
    add_index(:dce_lti_users, :lis_person_name_full)
  end
end
