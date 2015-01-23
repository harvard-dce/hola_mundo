describe CourseRole do
  it { should belong_to(:dce_lti_user) }
  it { should validate_presence_of(:dce_lti_user_id) }
  it { should have_db_index(:dce_lti_user_id) }

  it { should belong_to(:course) }
  it { should validate_presence_of(:course_id) }
  it { should have_db_index(:course_id) }

  it { should validate_presence_of(:role) }
  it { should have_db_index(:role) }
end
