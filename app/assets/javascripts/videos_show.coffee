$ ->
  if $('.videos-show span.video').length > 0
    window.onYouTubeIframeAPIReady = ->
      player = new YT.Player(
        'my_video_player',
        height: 390,
        width: 640,
        videoId: $('span.video').data('youtube-id')
        events: {}
      )
