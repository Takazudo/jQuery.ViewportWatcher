(function() {
  var wait;

  wait = function(time) {
    return $.Deferred(function(defer) {
      return setTimeout(function() {
        return defer.resolve();
      }, time);
    });
  };

  describe("foo", function() {
    return it("should be true", function() {
      return (expect(true)).to.be(true);
    });
  });

}).call(this);
