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
        console.log(ns);
        console.log(ns.viewport);
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
    it("should create instance object", function() {
      var o;
      o = new ns.Observation($.noop);
      return (expect(o.constructor)).to.be(ns.Observation);
    });
    it("should store passed configs", function() {
      var fn, o;
      fn = function() {};
      o = new ns.Observation(function(observer) {
        observer.when(fn, fn);
        observer.when(fn, fn);
        observer.when(fn, fn);
        return observer.when(fn, fn);
      });
      return (expect(o.configs.length)).to.be(4);
    });
    return it("should fire correct handler", function() {
      var o, spy1, spy2, spy3, spy4;
      spy1 = sinon.spy();
      spy2 = sinon.spy();
      spy3 = sinon.spy();
      spy4 = sinon.spy();
      o = new ns.Observation(function(observer) {
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
          return (900 <= w && w < 1200);
        }), spy4);
      });
      o.notify({
        width: 400
      });
      (expect(spy1.callCount)).to.be(0);
      (expect(spy2.callCount)).to.be(1);
      (expect(spy3.callCount)).to.be(0);
      return (expect(spy4.callCount)).to.be(0);
    });
  });

  describe("ns.Watcher", function() {
    it("should create instance object", function() {
      var o;
      o = new ns.Watcher($.noop);
      return (expect(o.constructor)).to.be(ns.Watcher);
    });
    return it("should receive watch settings", function() {
      var criteria1, criteria2, handler1, handler2, watcher;
      watcher = new ns.Watcher;
      criteria1 = function(width) {
        return (0 <= width && width < 800);
      };
      criteria2 = function(width) {
        return 800 <= width;
      };
      handler1 = function() {};
      handler2 = function() {};
      return watcher.watch(function(observer) {
        observer.when(criteria1, handler1);
        return observer.when(criteria2, handler2);
      });
    });
  });

}).call(this);
