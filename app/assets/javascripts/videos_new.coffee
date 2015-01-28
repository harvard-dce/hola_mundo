$ ->
  widget = ''

  postYoutubeId = (event) ->
    $('#uploading_in_progress, #player').show()
    $.ajax(
      type: 'POST',
      url: httpRoot + 'videos',
      data:
        video:
          youtube_id: event.data.videoId
      success: ->
        console.log('Worked!')
      error: (jqxhr, textStatus, errorThrown) ->
        console.log('jqxhr:', jqxhr)
        console.log('textStatus:', textStatus)
        console.log('errorThrown:', errorThrown)
    )

  showVideoPreview = (event) ->
    $('#uploading_in_progress').hide()
    new YT.Player(
      'player',
      height: 300,
      width: 480,
      videoId: event.data.videoId,
      events: {}
    )

   setVideoMetadata = (event) ->
     titleBase = $('#upload_widget').data('course-title')
     widget.setVideoPrivacy('unlisted')
     widget.setVideoTitle("#{titleBase} video upload")

  if $('.videos-new').length > 0
    window.onYouTubeIframeAPIReady = ->
      widget = new YT.UploadWidget(
        'upload_widget',
        width: 500,
        events:
          onUploadSuccess: postYoutubeId
          onProcessingComplete: showVideoPreview
          onApiReady: setVideoMetadata
      )
