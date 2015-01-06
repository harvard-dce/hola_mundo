$ ->
  token = $( 'meta[name="csrf-token"]' ).attr( 'content' )
  $.ajaxSetup(
    beforeSend: ( xhr ) ->
      xhr.setRequestHeader( 'X-CSRF-Token', token )
  )
