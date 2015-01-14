$ ->
  menuToggle = $('.js-centered-navigation-mobile-menu-toggle').unbind()
  $('#js-centered-navigation-menu').removeClass("show")

  menuToggle.on('click', (e) ->
    e.preventDefault()
    $('#js-centered-navigation-menu').slideToggle(->
      if($('#js-centered-navigation-menu').is(':hidden'))
        $('#js-centered-navigation-menu').removeAttr('style')
    )
  )
