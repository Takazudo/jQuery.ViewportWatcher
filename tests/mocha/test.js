(function() {
  var ns, wait;

  wait = function(time) {
    return $.Deferred(function(defer) {
      return setTimeout(function() {
        return defer.resolve();
      }, time);
    });
  };

  ns = $.ViewportWatcherNs;

  describe("ns.viewport", function() {
    describe(".width()", function() {
      return it("should return number", function() {
        return (expect(ns.viewport.width())).to.be.a('number');
      });
    });
    return describe(".height()", function() {
      return it("should return number", function() {
        return (expect(ns.viewport.height())).to.be.a('number');
      });
    });
  });

  describe("ns.Observation", function() {
    return it("should create instance object", function() {
      var o;
      o = new ns.Observation($.noop, this.noop);
      return (expect(o.constructor)).to.be(ns.Observation);
    });
  });

  describe("ns.Watcher", function() {
    describe("initialization", function() {
      return it("should create instance object", function() {
        var o;
        o = new ns.Watcher($.noop);
        return (expect(o.constructor)).to.be(ns.Watcher);
      });
    });
    describe("option: notify_on_init", function() {
      return it("should fire notification on init", function() {
        var o, spy;
        spy = sinon.spy();
        o = new ns.Watcher(function(observer) {
          observer.when((function(w) {
            return w < 300;
          }), spy);
          observer.when((function(w) {
            return (300 <= w && w < 600);
          }), spy);
          observer.when((function(w) {
            return (600 <= w && w < 900);
          }), spy);
          return observer.when((function(w) {
            return 900 <= w;
          }), spy);
        });
        return (expect(spy.calledOnce)).to.be(true);
      });
    });
    return describe("notification test", function() {
      var o, spy1, spy2, spy3, spy4;
      spy1 = null;
      spy2 = null;
      spy3 = null;
      spy4 = null;
      o = null;
      beforeEach(function() {
        spy1 = sinon.spy();
        spy2 = sinon.spy();
        spy3 = sinon.spy();
        spy4 = sinon.spy();
        return o = new ns.Watcher(function(observer) {
          observer.option({
            notify_on_init: false
          });
          observer.when((function(w) {
            return w < 300;
          }), spy1);
          observer.when((function(w) {
            return (300 <= w && w < 600);
          }), spy2);
          observer.when((function(w) {
            return (600 <= w && w < 900);
          }), spy3);
          return observer.when((function(w) {
            return 900 <= w;
          }), spy4);
        });
      });
      it("should fire correct handler when it received `notify`", function() {
        o.notify({
          width: 400
        });
        (expect(spy1.callCount)).to.be(0);
        (expect(spy2.callCount)).to.be(1);
        (expect(spy3.callCount)).to.be(0);
        return (expect(spy4.callCount)).to.be(0);
      });
      it("should fire `observationswitch` event when observation was switched", function() {
        var eventWatcher;
        eventWatcher = sinon.spy();
        o.on('observationswitch', eventWatcher);
        o.notify({
          width: 400
        });
        (expect(eventWatcher.callCount)).to.be(1);
        o.notify({
          width: 1000
        });
        return (expect(eventWatcher.callCount)).to.be(2);
      });
      it("should fire correct handler only once", function() {
        o.notify({
          width: 400
        });
        o.notify({
          width: 400
        });
        o.notify({
          width: 400
        });
        (expect(spy1.callCount)).to.be(0);
        (expect(spy2.callCount)).to.be(1);
        (expect(spy3.callCount)).to.be(0);
        return (expect(spy4.callCount)).to.be(0);
      });
      it("should handle complicated notification", function() {
        o.notify({
          width: 100
        });
        (expect(spy1.callCount)).to.be(1);
        (expect(spy2.callCount)).to.be(0);
        (expect(spy3.callCount)).to.be(0);
        (expect(spy4.callCount)).to.be(0);
        o.notify({
          width: 400
        });
        (expect(spy1.callCount)).to.be(1);
        (expect(spy2.callCount)).to.be(1);
        (expect(spy3.callCount)).to.be(0);
        (expect(spy4.callCount)).to.be(0);
        o.notify({
          width: 800
        });
        (expect(spy1.callCount)).to.be(1);
        (expect(spy2.callCount)).to.be(1);
        (expect(spy3.callCount)).to.be(1);
        (expect(spy4.callCount)).to.be(0);
        o.notify({
          width: 1000
        });
        (expect(spy1.callCount)).to.be(1);
        (expect(spy2.callCount)).to.be(1);
        (expect(spy3.callCount)).to.be(1);
        (expect(spy4.callCount)).to.be(1);
        o.notify({
          width: 100
        });
        (expect(spy1.callCount)).to.be(2);
        (expect(spy2.callCount)).to.be(1);
        (expect(spy3.callCount)).to.be(1);
        return (expect(spy4.callCount)).to.be(1);
      });
      return it("should not be notified after destroyed", function() {
        o.destroy();
        o.notify({
          width: 400
        });
        (expect(spy1.callCount)).to.be(0);
        (expect(spy2.callCount)).to.be(0);
        (expect(spy3.callCount)).to.be(0);
        return (expect(spy4.callCount)).to.be(0);
      });
    });
  });

}).call(this);
