$ ->
  widget = ''
  player = ''

  onUploadSuccess = (event) ->
    $('#uploading_in_progress').show()
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

  onProcessingComplete = (event) ->
    $('#uploading_in_progress').hide()
    player = new YT.Player(
      'player',
      height: 390,
      width: 640,
      videoId: event.data.videoId,
      events: {}
    )

  if $('.videos-index span.video').length > 0
    window.onYouTubeIframeAPIReady = ->
      player = new YT.Player(
        'player',
        height: 390,
        width: 640,
        videoId: $('span.video').data('youtube-id')
        events: {}
      )

  if $('.videos-new').length > 0
    window.onYouTubeIframeAPIReady = ->
      widget = new YT.UploadWidget(
        'upload_widget',
        width: 500,
        events:
          onUploadSuccess: onUploadSuccess
          onProcessingComplete: onProcessingComplete
      )
