requestAnimationFrame = window.requestAnimationFrame ||
window.webkitRequestAnimationFrame ||
window.mozRequestAnimationFrame ||
window.msRequestAnimationFrame ||
window.oRequestAnimationFrame ||
(callback) ->
  window.setTimeout(callback, 1000/60)

cancelAnimationFrame = window.cancelAnimationFrame ||
window.webkitCancelAnimationFrame ||
window.mozCancelAnimationFrame ||
window.msCancelAnimationFrame ||
window.oCancelAnimationFrame ||
(handle) ->
  window.clearTimeout(handle)

class InfiniteScroll
  constructor: (scrollHeight, scrollCallback, @option) ->
    @wrapper = document.body

    @lowExpand = if @option && @option.lowExpand then @option.lowExpand else 0.1 * scrollHeight
    @highExpand = if @option && @option.highExpand then @option.highExpand else 0.1 * scrollHeight
    @scrollPlaceholder = document.createElement 'div'
    @setScrollHeight(scrollHeight)
    if @wrapper.firstChild
      @wrapper.insertBefore @scrollPlaceholder, @wrapper.firstChild
    else
      @wrapper.appendChild @scrollPlaceholder

    if typeof scrollCallback == 'function'
      @scrollCallback = scrollCallback

    @addEventListener()

  setScrollHeight: (height) ->
    @scrollHeight = height
    @calcScrollHeight = @lowExpand + height + @highExpand
    @scrollPlaceholder.style.height = "#{@calcScrollHeight}px"

  addEventListener: () ->
    currentTop = document.body.scrollTop ||
      document.documentElement.scrollTop
    @scrollTo @calcScroll currentTop
    @eventHandler = requestAnimationFrame @addEventListener.bind(@)

  removeEventListener: () ->
    cancelAnimationFrame @eventHandler

  calcScroll: (target) ->
    dest = target
    if target < @lowExpand
      dest += @scrollHeight
    if target > @lowExpand + @scrollHeight
      dest -= @scrollHeight
    return dest

  scrollTo: (target) ->
    document.body.scrollTop = document.documentElement.scrollTop = target
    progress = (target - @lowExpand) / @scrollHeight
    if @scrollCallback
      @scrollCallback progress