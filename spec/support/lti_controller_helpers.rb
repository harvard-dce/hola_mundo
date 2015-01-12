module LtiControllerHelpers
  def stub_course_session_variables
    session[:resource_link_id] = 'resource_link_id'
    session[:context_title] = 'course title'
  end

  def stub_user
    DceLti::User.new.tap do |user|
      user.id = 1000
      if block_given?
        yield user
      end
      allow(DceLti::User).to receive(:find_by).and_return(user)
    end
  end
end
