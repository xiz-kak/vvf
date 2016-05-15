exec_on_ready = ->
  $('#loader-bg, #loader').height($(window).height()).css('display','block')

  setTimeout(stopload(), 100)

  $(window).on 'load', ->
    stopload()

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

  ###
  $('#pledge_pledge_shipping_attributes_nation_id').on 'change', ->
    alert('a')
    $.ajax
      url: "/shipping_rate"
      type: "POST"
      data: {reward_code: $(this).data('reward-code'), nation_id: $(this).val()}
      dataType: "json"
      success: (data, status, xhr) ->
        alert(xhr.responseText)
        $('#pledge_payment_shipping_rate').text(xhr.responseText)
        calcTotalAmount()
      error: (xhr, status, error) ->
        alert('Failed to load shipping_rate!!\n[Error] '+error)
  ###

  # Ignite change event.
  changeShipsToDiv()

  topBtn = $('#go-to-top')
  topBtn.hide()
  topHeader = $('.top-header')
  searchBtn = $('.top-header-btn')
  $(window).scroll ->
    if $(this).scrollTop() > 100
      topBtn.fadeIn()
    else
      topBtn.fadeOut()
    if $(this).scrollTop() > 700
      topHeader.removeClass('navbar-ghost')
      topHeader.addClass('navbar-default')
      searchBtn.removeClass('btn-white')
      searchBtn.addClass('btn-default')
    else
      topHeader.removeClass('navbar-default')
      topHeader.addClass('navbar-ghost')
      searchBtn.removeClass('btn-default')
      searchBtn.addClass('btn-white')
  topBtn.click ->
    $('body,html').animate({
        scrollTop: 0
    }, 500)
    return false
  $('#pledge-modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    if button.data('logged-in') == false
      document.location = '/login' # 一旦これで回避　ログインダイアログを頑張って作る
      return
    reward_code = button.data('reward-code')
    modal = $(this)
    $.ajax
      url: "/rewards/" + reward_code + "/new_pledge"
      type: "GET"
      data: {}
      dataType: "html"
      success: (data, status, xhr) ->
        modal.find('#pledge-info').html(data)
      error: (xhr, status, error) ->
        modal.modal('hide')
        alert('Failed to load pledge info!!\n[Error] '+error)

$(document).ready(exec_on_ready)
$(document).on('page:load', exec_on_ready)

changeShipsToDiv = ->
  $('.reward_ships_to').on 'change', ->
    switchOnShipsTo($(this))

switchOnShipsTo = (el) ->
  switch el.val()
    when '0'
      $('#'+el.data('estimated-delivery')).hide()
      $('#'+el.data('nation-group')).hide()
      $('#'+el.data('default-shipping-rate')).hide()
    when '1'
      $('#'+el.data('estimated-delivery')).show()
      $('#'+el.data('nation-group')).show()
      $('#'+el.data('default-shipping-rate')).hide()
    when '2'
      $('#'+el.data('estimated-delivery')).show()
      $('#'+el.data('nation-group')).show()
      $('#'+el.data('default-shipping-rate')).show()

###
calcTotalAmount = ->
  numA = $('#pledge_payment_amount').text()
  numB = $('#pledge_payment_shipping_rate').text()
  numA = parseFloat(numA)
  numB = parseFloat(numB)
  if numA == null
    $('#pledge_payment_amount').text('')
    return false
  if numB == null
    $('#pledge_payment_shipping_rate').text('')
    return false
  $('#pledge_payment_total_amount').text((numA+numB).toFixed(2))
###

$(document).bind 'page:change', ->
  $('.ckeditor').each ->
    CKEDITOR.replace($(this).attr('id'), {"toolbar":"mini", "height":"500"})

stopload = ->
  $('#loader-bg').delay(900).fadeOut(800)
  $('#loader').delay(600).fadeOut(300)
