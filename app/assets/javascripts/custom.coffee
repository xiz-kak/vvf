$(document).on 'ready page:load', ->
  $('form').on 'click', '.add_field', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
    changeShipsToDiv()

  $('form').on 'click', '.remove_field', (event) ->
    $(this).prev('input[name*=_destroy]').val('true')
    $(this).closest('div').hide()
    event.preventDefault()

  Cookies.set('tzoffset', (new Date()).getTimezoneOffset())

  $('.amount_to_pay').on 'change', ->
    numA = $('#pledge_pledge_payment_attributes_amount').val()
    numB = $('#pledge_pledge_payment_attributes_shipping_rate').val()
    numA = parseFloat(numA)
    numB = parseFloat(numB)
    if !numA
      $('#pledge_pledge_payment_attributes_amount').val('')
      return false
    if !numB
      $('#pledge_pledge_payment_attributes_shipping_rate').val('')
      return false
    $('#pledge_pledge_payment_attributes_total_amount').val((numA+numB).toFixed(2))

  # Ignite change event.
  changeShipsToDiv()

changeShipsToDiv = ->
  $('.reward_ships_to').on 'change', ->
    switchOnShipsTo($(this))

switchOnShipsTo = (el) ->
  switch el.val()
    when '1'
      $('#'+el.data('default-shipping-rate')).hide()
      $('#'+el.data('nation-group')).hide()
    when '2'
      $('#'+el.data('default-shipping-rate')).hide()
      $('#'+el.data('nation-group')).show()
    when '3'
      $('#'+el.data('default-shipping-rate')).show()
      $('#'+el.data('nation-group')).show()

$(document).bind 'page:change', ->
  $('.ckeditor').each ->
    CKEDITOR.replace($(this).attr('id'), {"toolbar":"mini"})
