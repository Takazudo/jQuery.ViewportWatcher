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
      (expect ns.viewport.width()).to.be.a 'number'

  describe ".height()", ->

    it "should return number", ->
      (expect ns.viewport.height()).to.be.a 'number'

describe "ns.Observation", ->

  it "should create instance object", ->
    o = new ns.Observation $.noop, @.noop
    (expect o.constructor).to.be ns.Observation

describe "ns.Watcher", ->
  
  describe "initialization", ->

    it "should create instance object", ->
      o = new ns.Watcher $.noop
      (expect o.constructor).to.be ns.Watcher

  describe "option: notify_on_init", ->

    it "should fire notification on init", ->
    
      spy = sinon.spy()
      o = new ns.Watcher (observer) ->
        observer.when ((w) -> (w < 300)), spy
        observer.when ((w) -> (300 <= w < 600)), spy
        observer.when ((w) -> (600 <= w < 900)), spy
        observer.when ((w) -> (900 <= w)), spy
      (expect spy.calledOnce).to.be true

  describe "notification test", ->

    spy1 = null
    spy2 = null
    spy3 = null
    spy4 = null
    o = null

    beforeEach ->
      spy1 = sinon.spy()
      spy2 = sinon.spy()
      spy3 = sinon.spy()
      spy4 = sinon.spy()
      o = new ns.Watcher (observer) ->
        observer.option notify_on_init: false
        observer.when ((w) -> (w < 300)), spy1
        observer.when ((w) -> (300 <= w < 600)), spy2
        observer.when ((w) -> (600 <= w < 900)), spy3
        observer.when ((w) -> (900 <= w)), spy4

    it "should fire correct handler when it received `notify`", ->
      o.notify width: 400
      (expect spy1.callCount).to.be 0
      (expect spy2.callCount).to.be 1
      (expect spy3.callCount).to.be 0
      (expect spy4.callCount).to.be 0

    it "should fire `observationswitch` event when observation was switched", ->
      eventWatcher = sinon.spy()
      o.on 'observationswitch', eventWatcher
      o.notify width: 400
      (expect eventWatcher.callCount).to.be 1
      o.notify width: 1000
      (expect eventWatcher.callCount).to.be 2

    it "should fire correct handler only once", ->
      o.notify width: 400
      o.notify width: 400
      o.notify width: 400
      (expect spy1.callCount).to.be 0
      (expect spy2.callCount).to.be 1
      (expect spy3.callCount).to.be 0
      (expect spy4.callCount).to.be 0

    it "should handle complicated notification", ->
      o.notify width: 100
      (expect spy1.callCount).to.be 1
      (expect spy2.callCount).to.be 0
      (expect spy3.callCount).to.be 0
      (expect spy4.callCount).to.be 0
      o.notify width: 400
      (expect spy1.callCount).to.be 1
      (expect spy2.callCount).to.be 1
      (expect spy3.callCount).to.be 0
      (expect spy4.callCount).to.be 0
      o.notify width: 800
      (expect spy1.callCount).to.be 1
      (expect spy2.callCount).to.be 1
      (expect spy3.callCount).to.be 1
      (expect spy4.callCount).to.be 0
      o.notify width: 1000
      (expect spy1.callCount).to.be 1
      (expect spy2.callCount).to.be 1
      (expect spy3.callCount).to.be 1
      (expect spy4.callCount).to.be 1
      o.notify width: 100
      (expect spy1.callCount).to.be 2
      (expect spy2.callCount).to.be 1
      (expect spy3.callCount).to.be 1
      (expect spy4.callCount).to.be 1

    it "should not be notified after destroyed", ->
      o.destroy()
      o.notify width: 400
      (expect spy1.callCount).to.be 0
      (expect spy2.callCount).to.be 0
      (expect spy3.callCount).to.be 0
      (expect spy4.callCount).to.be 0

