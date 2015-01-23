describe 'Filtering and sorting videos' do
  context 'instructors' do
    before do
      @course = create(:course, resource_link_id: 'a resource_link_id')
      ENV['FAKE_USER_ID'] = create(:dce_lti_user).id.to_s
      page.set_rack_session(roles: ['instructor'])
      page.set_rack_session(resource_link_id: @course.resource_link_id)
    end

    context 'a course that requires review' do
      before do
        @course.review_required = true
        @course.save
        @approved_videos = create_list(:video, 2, course: @course)
        @approved_videos.each do |video|
          video.approved = true
          video.save!
        end
        @unapproved_videos = create_list(:video, 2, course: @course)
      end

      scenario 'can toggle approved / unapproved state' do
        visit '/'

        select('Approved', from: 'Approval')
        click_on 'Go'

        @approved_videos.each do |video|
          expect(page).to have_css("#video_#{video.id}")
        end
        @unapproved_videos.each do |video|
          expect(page).not_to have_css("#video_#{video.id}")
        end

        select('Not Approved', from: 'Approval')
        click_on 'Go'

        @approved_videos.each do |video|
          expect(page).not_to have_css("#video_#{video.id}")
        end
        @unapproved_videos.each do |video|
          expect(page).to have_css("#video_#{video.id}")
        end

        select('- All Videos -', from: 'Approval')
        click_on 'Go'

        @approved_videos.each do |video|
          expect(page).to have_css("#video_#{video.id}")
        end
        @unapproved_videos.each do |video|
          expect(page).to have_css("#video_#{video.id}")
        end
      end

      scenario 'can filter on user name' do
        first_video = @approved_videos.first
        last_video = @approved_videos.last

        visit '/'
        user_name = first_video.dce_lti_user.lis_person_name_full

        fill_in('Name', with: user_name)
        click_on 'Go'

        expect(page).to have_css("#video_#{first_video.id}")
        expect(page).not_to have_css("#video_#{last_video.id}")
      end
    end

    context 'sorting' do
      before do
        first_user = create(:dce_lti_user, lis_person_name_full: 'AAA')
        last_user = create(:dce_lti_user, lis_person_name_full: 'ZZZ')

        @oldest_video = create(:video, course: @course, dce_lti_user: last_user)
        @zzz_video = @oldest_video
        sleep 1
        @newest_video = create(:video, course: @course, dce_lti_user: first_user)
        @aaa_video = @newest_video
      end

      scenario 'can sort on date' do
        visit '/'

        select('Newest to oldest', from: 'Sort by')
        click_on 'Go'

        expect(page).to have_css(".video-list #video_#{@newest_video.id}:first-child")

        select('Oldest to newest', from: 'Sort by')
        click_on 'Go'

        expect(page).to have_css(".video-list #video_#{@oldest_video.id}:first-child")

        select('Newest to oldest', from: 'Sort by')
        click_on 'Go'

        expect(page).to have_css(".video-list #video_#{@newest_video.id}:first-child")
      end

      scenario 'can sort on name' do
        visit '/'

        select('Name, a-z', from: 'Sort by')
        click_on 'Go'

        expect(page).to have_css(".video-list #video_#{@aaa_video.id}:first-child")

        select('Name, z-a', from: 'Sort by')
        click_on 'Go'

        expect(page).to have_css(".video-list #video_#{@zzz_video.id}:first-child")

        select('Name, a-z', from: 'Sort by')
        click_on 'Go'

        expect(page).to have_css(".video-list #video_#{@aaa_video.id}:first-child")
      end
    end
  end

  context 'learners' do
    before do
      @course = create(:course, resource_link_id: 'a resource_link_id')
      ENV['FAKE_USER_ID'] = create(:dce_lti_user).id.to_s
      page.set_rack_session(roles: ['learner'])
      page.set_rack_session(resource_link_id: @course.resource_link_id)
      @approved_videos = create_list(:video, 2, course: @course)
      @approved_videos.each do |video|
        video.approved = true
        video.save!
      end
    end

    scenario 'can filter on user name' do
      first_video = @approved_videos.first
      last_video = @approved_videos.last

      visit '/'
      user_name = first_video.dce_lti_user.lis_person_name_full

      fill_in('Name', with: user_name)
      click_on 'Go'

      expect(page).to have_css("#video_#{first_video.id}")
      expect(page).not_to have_css("#video_#{last_video.id}")
    end
  end
end
