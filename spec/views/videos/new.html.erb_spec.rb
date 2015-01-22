describe 'videos/new.html.erb' do
  it 'dumps the course title into a data attribute' do
    course = build(:course, title: 'footest')
    allow(view).to receive(:course).and_return(course)

    render

    expect(rendered).to have_css(%Q|#upload_widget[data-course-title="#{course.title}"]|)
  end

  it 'gives notice when a video will need to be reviewed' do
    course = build(:course, review_required: true)
    allow(view).to receive(:course).and_return(course)

    render

    expect(rendered).to have_content(t('videos.review_required'))
  end

  it "does not give notice when doesn't need review" do
    course = build(:course, review_required: false)
    allow(view).to receive(:course).and_return(course)

    render

    expect(rendered).not_to have_content(t('videos.review_required'))
  end

  it "gives notice when you've already uploaded a video" do
    assign(:my_video, build(:video))
    allow(view).to receive(:course).and_return(build(:course))

    render

    expect(rendered).to have_content(t('videos.already_uploaded'))
  end
end
