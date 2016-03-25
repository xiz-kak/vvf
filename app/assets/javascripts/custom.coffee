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
    calcTotalAmount()

  $('#pledge_pledge_shipping_attributes_nation_id').on 'change', ->
    $.ajax
      url: "/shipping_rate"
      type: "POST"
      data: {reward_id: $(this).data('reward-id'), nation_id: $(this).val()}
      dataType: "json"
      success: (data, status, xhr) ->
        $('#pledge_pledge_payment_attributes_shipping_rate').val(xhr.responseText)
        calcTotalAmount()
      error: (xhr, status, error) ->
        alert('Failed to load shipping_rate!!\n[Error] '+error)

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

calcTotalAmount = ->
  numA = $('#pledge_pledge_payment_attributes_amount').val()
  numB = $('#pledge_pledge_payment_attributes_shipping_rate').val()
  numA = parseFloat(numA)
  numB = parseFloat(numB)
  if numA == null
    $('#pledge_pledge_payment_attributes_amount').val('')
    return false
  if numB == null
    $('#pledge_pledge_payment_attributes_shipping_rate').val('')
    return false
  $('#pledge_pledge_payment_attributes_total_amount').val((numA+numB).toFixed(2))

$(document).bind 'page:change', ->
  $('.ckeditor').each ->
    CKEDITOR.replace($(this).attr('id'), {"toolbar":"mini"})
