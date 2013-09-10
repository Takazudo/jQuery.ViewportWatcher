# tiny util
wait = (time) ->
  return $.Deferred (defer) ->
    setTimeout ->
      defer.resolve()
    , time

ns = $.ViewportWatcherNs

describe "ns.viewport", ->

  describe ".width()", ->

    it "should return number", ->
      console.log ns
      console.log ns.viewport
      (expect ns.viewport.width()).to.be.a 'number'

  describe ".height()", ->

    it "should return number", ->
      (expect ns.viewport.height()).to.be.a 'number'

describe "ns.Observation", ->

  it "should create instance object", ->
    o = new ns.Observation $.noop
    (expect o.constructor).to.be ns.Observation

  it "should store passed configs", ->
    fn = ->
    o = new ns.Observation (observer) ->
      observer.when fn, fn
      observer.when fn, fn
      observer.when fn, fn
      observer.when fn, fn
    (expect o.configs.length).to.be 4

  it "should fire correct handler", ->
    spy1 = sinon.spy()
    spy2 = sinon.spy()
    spy3 = sinon.spy()
    spy4 = sinon.spy()
    o = new ns.Observation (observer) ->
      observer.when ((w) -> (w < 300)), spy1
      observer.when ((w) -> (300 <= w < 600)), spy2
      observer.when ((w) -> (600 <= w < 900)), spy3
      observer.when ((w) -> (900 <= w < 1200)), spy4
    o.notify width:400
    (expect spy1.callCount).to.be 0
    (expect spy2.callCount).to.be 1
    (expect spy3.callCount).to.be 0
    (expect spy4.callCount).to.be 0

describe "ns.Watcher", ->
  
  it "should create instance object", ->
    o = new ns.Watcher $.noop
    (expect o.constructor).to.be ns.Watcher

  it "should receive watch settings", ->

    watcher = new ns.Watcher

    criteria1 = (width) -> 0 <= width < 800
    criteria2 = (width) -> 800 <= width
    handler1 = ->
    handler2 = ->

    watcher.watch (observer) ->
      observer.when criteria1, handler1
      observer.when criteria2, handler2

    #o = watcher.observations[0]





