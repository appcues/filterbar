/*! filterbar 0.0.1 */

/**
 * State manager for individuals filters.
 */

(function() {
  var Evented, Filter, Filterbar, eventSplitter, eventsApi, triggerEvents, utils,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Filterbar = (function(_super) {
    __extends(Filterbar, _super);

    function Filterbar(options) {
      this.options = options;
    }

    Filterbar.prototype.render = function() {};

    Filterbar.prototype.remove = function() {};

    Filterbar.prototype.addFilter = function(filter) {};

    Filterbar.prototype.removeFilter = function(filter) {};

    return Filterbar;

  })(Evented);


  /**
   * Individual filter.
   */

  Filter = (function(_super) {
    __extends(Filter, _super);

    function Filter(options) {
      this.options = options;
    }

    Filter.prototype.render = function() {};

    Filter.prototype.remove = function() {};

    return Filter;

  })(Evented);


  /**
   * Events object, lifted from Backbone.js.
   * @type {object}
   */

  Evented = {
    on: function(name, callback, context) {
      var events;
      if (!eventsApi(this, 'on', name, [callback, context]) || !callback) {
        return this;
      }
      if (this._events == null) {
        this._events = {};
      }
      events = this._events[name] || (this._events[name] = []);
      events.push({
        callback: callback,
        context: context,
        ctx: context || this
      });
      return this;
    },
    off: function(name, callback, context) {
      var ev, events, i, names, retain, _i, _j, _len, _len1;
      if (!this._events || !eventsApi(this, 'off', name, [callback, context])) {
        return this;
      }
      if (!name && !callback && !context) {
        this._events = {};
        return this;
      }
      i = 0;
      names = (name ? [name] : utils.keys(this._events));
      for (_i = 0, _len = names.length; _i < _len; _i++) {
        name = names[_i];
        if (events = this._events[name]) {
          this._events[name] = retain = [];
          if (callback || context) {
            for (_j = 0, _len1 = events.length; _j < _len1; _j++) {
              ev = events[_j];
              if ((callback && callback !== ev.callback && callback !== ev.callback._callback) || (context && context !== ev.context)) {
                retain.push(ev);
              }
            }
          }
          if (!retain.length) {
            delete this._events[name];
          }
        }
      }
      return this;
    },
    trigger: function() {
      var allEvents, args, events, name;
      name = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (!this._events) {
        return this;
      }
      if (!eventsApi(this, 'trigger', name, args)) {
        return this;
      }
      events = this._events[name];
      allEvents = this._events.all;
      if (events) {
        triggerEvents(events, args);
      }
      if (allEvents) {
        triggerEvents(allEvents, arguments);
      }
      return this;
    }
  };

  eventSplitter = /\s+/;

  eventsApi = function(obj, action, name, rest) {
    var key, names, _i, _len;
    if (!name) {
      return true;
    }
    if (typeof name === 'object') {
      for (key in name) {
        obj[action].apply(obj, [key, name[key]].concat(rest));
      }
      return false;
    }
    if (eventSplitter.test(name)) {
      names = name.split(eventSplitter);
      for (_i = 0, _len = names.length; _i < _len; _i++) {
        name = names[_i];
        obj[action].apply(obj, [name].concat(rest));
      }
      return false;
    }
    return true;
  };

  triggerEvents = function(events, args) {
    var a1, a2, a3, ev, i, l, _results;
    i = -1;
    l = events.length;
    a1 = args[0];
    a2 = args[1];
    a3 = args[2];
    switch (args.length) {
      case 0:
        while (++i < l) {
          (ev = events[i]).callback.call(ev.ctx);
        }
        break;
      case 1:
        while (++i < l) {
          (ev = events[i]).callback.call(ev.ctx, a1);
        }
        break;
      case 2:
        while (++i < l) {
          (ev = events[i]).callback.call(ev.ctx, a1, a2);
        }
        break;
      case 3:
        while (++i < l) {
          (ev = events[i]).callback.call(ev.ctx, a1, a2, a3);
        }
        break;
      default:
        _results = [];
        while (++i < l) {
          _results.push((ev = events[i]).callback.apply(ev.ctx, args));
        }
        return _results;
    }
  };

  utils = {
    keys: Object.keys || function(obj) {
      var key, keys;
      if (obj !== Object(obj)) {
        throw new TypeError('Invalid object');
      }
      keys = [];
      for (key in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
          keys.push(key);
        }
      }
      return keys;
    }
  };

}).call(this);
