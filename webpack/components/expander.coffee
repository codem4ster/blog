`import $ from 'jquery'`


# Daha fazla göster demeye yarayan kütüphane
# @elem daha fazla göster düğmesinin jquery cinsinden nesnesi
# @item_selector hangi tipteki elemanları gizleyip gösterecek. Örn: 'li' ya da 'tr'
# @parent_elm selectorleri içerisinde barındıran eleman, aynı zamanda
#   @elem'in parent'ı olmak zorundadır. Eğer verilmezse class @elem'in bir üst
#   dom objesini parent kabul eder.
class Expander
  constructor: (@elem, @item_selector, @parent_elm = null) ->
    @item_count = @elem.attr('data-item-count') || 1
    if @parent_elm
      @list = @elem.closest(@parent_elm)
    else
      @list = @elem.parent()
    @item_count -= @list.find(@item_selector + '.active').length
    @item_count = 0 if @item_count < 0
    link_count = @list.find(@item_selector + ':not(.active)').length
    @elem.css(display: 'flex') if link_count > @item_count
    @elem.html('<span class="ico-angle-double-down"></span>Tümünü Göster</div>')
    @list.find(@item_selector + ':not(.active)').slice(0, @item_count).css(display: 'flex')
    @expanded = false
    @elem.on('click', @on_click)

  expand: ->
    elems = @list.find(@item_selector + ':not(.active)').slice(@item_count)
    elems.stop().slideDown
      complete: =>
        @elem.html('<span class="ico-angle-double-up"></span>Listeyi Daralt</div>')
        return
    @expanded = true
    return

  narrow: ->
    @list.find(@item_selector + ':not(.active)').slice(@item_count).stop().slideUp (=>
      @elem.html('<span class="ico-angle-double-down"></span>Tümünü Göster</div>')
    )
    @expanded = false
    return

  on_click: =>
    if @expanded
      @narrow()
    else
      @expand()
    return

`export default Expander`