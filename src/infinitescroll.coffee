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
  constructor: (@wrapper, scrollHeight, scrollCallback, @option) ->
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
    if target == @lastScrollTop
      return
    document.body.scrollTop = document.documentElement.scrollTop = target
    progress = (target - @lowExpand) / @scrollHeight
    @lastScrollTop = target
    if @scrollCallback
      @scrollCallback progress

  calcProgressToScroll: (progress) ->
    return @lowExpand + progress * @scrollHeight

  travelTo: (target, callback) ->
    if @isTraveling
      return
    @isTraveling = true
    { scroll, progress } = target
    currentTop = @lastScrollTop
    if typeof scroll == 'undefined' && typeof progress != 'undefined'
      scroll = @calcProgressToScroll progress
    if scroll < currentTop
      scroll += @scrollHeight
    travel = () =>
      currentTop += Math.ceil (scroll - currentTop) / 30
      @scrollTo @calcScroll currentTop
      if Math.abs(currentTop - scroll) < 1
        cancelAnimationFrame @travelHandler
        if callback && typeof callback == 'function'
          callback()
        @isTraveling = false
      else
        @travelHandler = requestAnimationFrame travel
    @travelHandler = requestAnimationFrame travel