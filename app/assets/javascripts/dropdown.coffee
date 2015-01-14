$ ->
  $(".dropdown-button").click(->
    rootElement = $(this).closest('.video').attr('id')
    $("##{rootElement}").find(".dropdown-menu").toggleClass("show-menu")
    $(".dropdown-menu > li").click(->
      $(".dropdown-menu").removeClass("show-menu")
    )
  )
