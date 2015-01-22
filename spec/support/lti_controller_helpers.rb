module LtiControllerHelpers
  def stub_course_session_variables
    session[:resource_link_id] = 'resource_link_id'
    session[:context_title] = 'course title'
  end

  def stub_course(
    resource_link_id: 'resource link id',
    context_title: 'context title'
  )
    session[:resource_link_id] = resource_link_id
    session[:context_title] = context_title

    build(:course, id: 1000).tap do |course|
      allow(course).to receive_messages(:title= => true , new_record?: true, save!: true)
      allow(Course).to receive(:find_or_initialize_by).and_return(course)
    end
  end

  def stub_user
    build(:dce_lti_user, id: 1000).tap do |user|
      allow(DceLti::User).to receive(:find_by).and_return(user)
    end
  end
end
