$ ->
  if $('.videos-index .video, .videos-show .video').length > 0
    window.onYouTubeIframeAPIReady = ->
      $('.youtube_container').click( (e) ->
        e.preventDefault()
        player = new YT.Player(
          $(this).attr('id'),
          playerVars:
            modestbranding: true
          height: '100%',
          width: '100%',
          videoId: $(this).data('youtube-id')
          events:
            onReady: (event) ->
              event.target.playVideo()
        )
      )
