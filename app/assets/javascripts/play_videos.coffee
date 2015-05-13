$ ->
  if $('.videos-index .video, .videos-show .video').length > 0
    window.onYouTubeIframeAPIReady = ->
      $('.youtube_modal_container').click( (e) ->
        playerId = $(this).attr('id')
        videoContainer = $(this).data('video-container')
        youtubeId = $(this).data('youtube-id')
        e.preventDefault()
        player = new YT.Player(
          playerId,
          playerVars:
            modestbranding: true
          height: '100%',
          width: '100%',
          videoId: youtubeId
          events:
            onReady: (event) ->
              event.target.playVideo()
        )
        $("##{videoContainer} .modal-close").click( (e) ->
          player.stopVideo()
        )
      )
