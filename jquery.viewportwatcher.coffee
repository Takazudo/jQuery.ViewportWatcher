do ($ = jQuery) ->

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
  # ns.ObservationConfig

  class ns.ObservationConfig
    
    constructor: (@criteria, @handler) ->

    test: (info) ->
      return @criteria info.width

    fire: ->
      @handler()

  # ============================================================
  # ns.Observation

  class ns.Observation
    
    constructor: (initializer) ->
      @configs = []
      initializer(this)

    when: (criteria, handler) ->
      o = new ns.ObservationConfig criteria, handler
      @configs.push o
    
    notify: (info) ->
      for c in @configs
        if c.test info
          c.fire()
          break

  # ============================================================
  # ns.Watcher

  class ns.Watcher

    constructor: ->
      @observations = []

    watch: (initializer) ->
      o = new ns.Observation initializer
      @observations.push o

  # ============================================================
  # globalify

  $.ViewportWatcherNs = ns
  $.ViewportWatcher = ns.Watcher
