describe Course do
  it { should have_many(:videos).dependent(:destroy) }
  it { should validate_presence_of(:resource_link_id) }
  it { should have_db_index(:resource_link_id).unique(true) }
  it { should ensure_length_of(:resource_link_id).is_at_most(255) }

  it { should ensure_length_of(:title).is_at_most(255) }

  context 'review_required' do
    it 'is true by default' do
      expect(described_class.new.review_required).to be true
    end
  end

  context '#toggle_review_required' do
    it 'flips "review_required" between states' do
      course = build(:course, review_required: false)
      course.toggle_review_required

      expect(course.review_required).to eq true

      course.toggle_review_required
      expect(course.review_required).to eq false
    end
  end
end
