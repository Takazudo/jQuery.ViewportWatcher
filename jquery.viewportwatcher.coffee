do ($ = jQuery) ->

  $window = $(window)

  # https://github.com/tysonmatanich/viewportSize
  viewportSize = window.viewportSize
  # https://github.com/Takazudo/EveEve
  EveEve = window.EveEve

  # define namespaces
  ns = {}
  ns.viewport = {}

  # ============================================================
  # ns.viewport

  ns.viewport.width = ->
    viewportSize.getWidth()
  ns.viewport.height = ->
    viewportSize.getHeight()

  # ============================================================
  # throttle / debounce from underscore.js
  # http://documentcloud.github.com/underscore/

  ns.limit = (func, wait, debounce) ->
    timeout = null
    return ->
      context = this
      args = arguments
      throttler = ->
        timeout = null
        func.apply context, args

      clearTimeout timeout if debounce
      timeout = setTimeout(throttler, wait) if debounce or not timeout

  ns.throttle = (func, wait) ->
    return ns.limit func, wait, false

  ns.debounce = (func, wait) ->
    return ns.limit func, wait, true

  # ============================================================
  # WinWatcher

  class ns.WinWatcher extends EveEve
    eventNames = 'resize orientationchange'
    constructor: ->
      $window.bind eventNames, =>
        @trigger 'resize'

  # put instance under namespace
  ns.winWatcher = new ns.WinWatcher

  # ============================================================
  # ns.Observation

  class ns.Observation
    
    constructor: (@criteria, @handlers) ->
      @_handlerFired = false
      @active = false

    handleNotification: (info) ->
      if (@_shouldIHandle info) and (not @_handlerFired)
        @handlers.match()
        @active = true
        @_handlerFired = true
        return true
      else
        return false

    resetFiredFlag: ->
      @_handlerFired = false

    _shouldIHandle: (info) ->
      return @criteria info.width

  # ============================================================
  # ns.Watcher

  class ns.Watcher extends EveEve

    @defaults =
      notify_on_init: true
      throttle_millisec: 200

    constructor: (initializer) ->
      @_observations = []
      initializer(this)
      unless @options
        @option()
      if @options.notify_on_init is true
        @_invokeNotification()
      @_eventify()

    option: (options = {}) ->
      @options = $.extend {}, ns.Watcher.defaults, options

    when: (criteria, handlers) ->
      o = new ns.Observation criteria, handlers
      @_observations.push o
      return this
    
    notify: (info) ->
      firedOne = null
      for o in @_observations
        if o.handleNotification info
          firedOne = o
        if firedOne isnt null
          break
      if firedOne isnt null
        for o in @_observations
          unless o is firedOne
            o.resetFiredFlag()
        @trigger 'observationswitch', info
        
    destroy: ->
      ns.winWatcher.off 'resize', @_resizeHandler
      @_observations.length = 0
      @off()

    _invokeNotification: ->
      @notify width: ns.viewport.width()

    _eventify: ->
      @_resizeHandler = ns.throttle =>
        @_invokeNotification()
        @trigger 'resize'
      , @options.throttle_millisec
      ns.winWatcher.on 'resize', @_resizeHandler
    

  # ============================================================
  # globalify

  $.ViewportWatcherNs = ns
  $.ViewportWatcher = ns.Watcher
