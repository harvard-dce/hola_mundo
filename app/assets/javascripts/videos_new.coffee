$ ->
  preview = {}

  getYoutubeId = (youtubeUrl) ->
  # h/t to http://stackoverflow.com/a/5831191/4279033
    re = /https?:\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube(?:-nocookie)?\.com\S*[^\w\s-])([\w-]{11})(?=[^\w-]|$)(?![?=&+%\w.-]*(?:['"][^<>]*>|<\/a>))[?=&+%\w.-]*/ig
    youtubeUrl.replace(re, "$1")

  initializeSourceSwitching = ->
    inputSelector = 'input[name="video[source]"]'
    selectedInput = $('input[name="video[source]"]:checked').val()
    $("##{selectedInput}").show()
    $(inputSelector).change( (e) ->
      selectedValue = $(this).val()
      $('#existing,#no_video').hide()
      $("##{selectedValue}").show('fast')
      if selectedValue == 'no_video'
        $('#preview').fadeTo('slow', 0.2)
      else
        $('#preview').fadeTo('slow', 1)
    )

  displayExistingVideo = (youtubeId) ->
    $('#preview').css('visibility','visible')
    preview.cueVideoById(youtubeId)

  watchForExistingYoutubeUrls = ->
    $('#video_existing_youtube_video').change( ->
      youtubeId = getYoutubeId($('#video_existing_youtube_video').val())
      displayExistingVideo(youtubeId)
    )

  setVideoUrlOnSubmit = (e) ->
    sourceChoice = $("input[name='video[source]']:checked").val()
    videoId = ''
    if sourceChoice == 'existing'
      videoId = getYoutubeId($('#video_existing_youtube_video').val())
    else
      videoId = ''

    $('#video_youtube_id').val(videoId)
    if videoId == '' && sourceChoice != 'no_video'
      $('#submission_error').show('fast')
      false

  if $('.videos-new,.videos-create').length > 0
    initializeSourceSwitching()
    window.onYouTubeIframeAPIReady = ->
      watchForExistingYoutubeUrls()
      preview = new YT.Player(
        'preview',
        height: 300,
        playerVars:
          autoplay: 0
        width: 480,
        events:
          onReady: (event) ->
            if $('#video_youtube_id').val() != ''
              displayExistingVideo($('#video_youtube_id').val())
      )
    $('form#new_video').submit( setVideoUrlOnSubmit )
