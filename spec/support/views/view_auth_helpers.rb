module ViewAuthHelpers
  def stub_instructor_role
    allow(view).to receive_message_chain(:course, :user_has_role?).and_return(true)
  end

  def stub_learner_role
    allow(view).to receive_message_chain(:course, :user_has_role?).and_return(false)
  end
end
