describe 'videos/_filters.html.erb' do
  it 'grabs info from the FilterSet' do
    allow(FilterSet).to receive(:sort_by_values).and_return([])
    allow(view).to receive(:course).and_return(build(:course))
    allow(view).to receive(:current_user).and_return(
      build(:dce_lti_user)
    )
    assign(:filter_set, FilterSet.new({}))

    render

    expect(FilterSet).to have_received(:sort_by_values)
  end
end
