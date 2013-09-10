/*! jQuery.viewportWatcher (https://github.com/Takazudo/jQuery.viewportWatcher)
 * lastupdate: 2013-09-10
 * version: 0.0.0
 * author: 'Takazudo' Takeshi Takatsudo <takazudo@gmail.com>
 * License: MIT */
(function() {
  (function($) {
    var EveEve, ns, viewportSize;
    viewportSize = window.viewportSize;
    EveEve = window.EveEve;
    ns = {};
    ns.viewport = {};
    ns.viewport.width = function() {
      return viewportSize.getWidth();
    };
    ns.viewport.height = function() {
      return viewportSize.getHeight();
    };
    ns.ObservationConfig = (function() {
      function ObservationConfig(criteria, handler) {
        this.criteria = criteria;
        this.handler = handler;
      }

      ObservationConfig.prototype.test = function(info) {
        return this.criteria(info.width);
      };

      ObservationConfig.prototype.fire = function() {
        return this.handler();
      };

      return ObservationConfig;

    })();
    ns.Observation = (function() {
      function Observation(initializer) {
        this.configs = [];
        initializer(this);
      }

      Observation.prototype.when = function(criteria, handler) {
        var o;
        o = new ns.ObservationConfig(criteria, handler);
        return this.configs.push(o);
      };

      Observation.prototype.notify = function(info) {
        var c, _i, _len, _ref, _results;
        _ref = this.configs;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          c = _ref[_i];
          if (c.test(info)) {
            c.fire();
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      return Observation;

    })();
    ns.Watcher = (function() {
      function Watcher() {
        this.observations = [];
      }

      Watcher.prototype.watch = function(initializer) {
        var o;
        o = new ns.Observation(initializer);
        return this.observations.push(o);
      };

      return Watcher;

    })();
    $.ViewportWatcherNs = ns;
    return $.ViewportWatcher = ns.Watcher;
  })(jQuery);

}).call(this);
