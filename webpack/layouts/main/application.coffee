`import _ from 'lodash'`
`import $ from 'jquery'`
`import 'bootstrap'`
`import 'fonts.css'`
`import 'fontello/css/fontello.css'`
`import './application.scss'`
`import 'code.jpg'`
`import './logo.png'`


breakpoints = [576, 768, 992, 1200, Infinity]
header = $('header')
main_elm = $('main')

last_breakpoint = null
$(window).resize ->
  size = window.innerWidth
  point = null
  for breakpoint, i in breakpoints
    if size <= breakpoint
      point = i
      break
  if point != last_breakpoint
    $(window).trigger('breakpoint-changed', point)

  last_breakpoint = point
  return

scrollHandler = ->
  $(window).trigger('scrolled', $(window).scrollTop())
  return

scrollTimeout = undefined
# global for any pending scrollTimeout
$(window).scroll ->
  if scrollTimeout
    clearTimeout scrollTimeout
    scrollTimeout = null
  scrollTimeout = setTimeout(scrollHandler, 50)
  return


set_main_position = ->
  main_elm.css('padding-top', header.height())


set_main_position()
$(window).on 'breakpoint-changed', (->
  setTimeout set_main_position, 500
)

$(window).on 'scroll', ->
  position = $(window).scrollTop()
  if position > 100
    $('.navbar-brand img').css('width', '2.3em')
    $('#search-form').removeClass('my-3').addClass('my-1')
  else
    $('.navbar-brand img').css('width', '')
    $('#search-form').removeClass('my-1').addClass('my-3')

$(document).on 'focus', '.form-control', ->
  $(this).removeClass('is-invalid')
  return