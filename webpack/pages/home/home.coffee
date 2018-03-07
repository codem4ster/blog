`import $ from 'jquery'`
`import './data_board.jpg'`
`import './home.scss'`

search_wrapper = $('#search-wrapper')
categories = $('#category-wrapper')
parallax = $('#parallax')
initial_parallax_height = null

relocate_categories = ->
  start_position = parallax.height()
  categories.css('padding-top', start_position - 100)
  initial_parallax_height = parallax.height()

relocate_categories()
categories.css('display', 'block')

$(window).on 'breakpoint-changed', (->
  setTimeout relocate_categories, 500
)
$(window).on 'scroll', ->
  position = $(window).scrollTop()
  if position < 800
    diff = position / 2
    parallax.css('height', initial_parallax_height-diff)
  else
    parallax.css('height', '')