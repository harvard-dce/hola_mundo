$ ->
  $('#flash').find('.close').click( (e) ->
    e.preventDefault()
    $(this).closest('.flash-container').hide('slow')
  )
