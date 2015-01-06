describe Video do
  it { should validate_presence_of(:dce_lti_user_id) }
  it { should have_db_index(:dce_lti_user_id) }

  it { should validate_presence_of(:youtube_id) }
  it { should ensure_length_of(:youtube_id).is_at_most(20) }

  it { should have_db_index(:resource_link_id) }
  it { should validate_presence_of(:resource_link_id) }
  it { should ensure_length_of(:resource_link_id).is_at_most(255) }
end
