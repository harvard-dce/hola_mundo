describe Course do
  it { should have_many(:videos).dependent(:destroy) }

  it { should validate_presence_of(:resource_link_id) }
  it { should validate_length_of(:resource_link_id).is_at_most(255) }
  it { should have_db_index(:resource_link_id).unique(true) }

  it { should have_many(:course_roles).dependent(:destroy) }
  it { should have_many(:dce_lti_users).through(:course_roles) }

  it { should validate_length_of(:title).is_at_most(255) }

  it { should validate_length_of(:welcome_message).is_at_most(2.kilobytes) }
  it { should validate_length_of(:upload_description).is_at_most(2.kilobytes) }


  context 'review_required' do
    it 'is false by default' do
      expect(described_class.new.review_required).to be false
    end
  end
end
