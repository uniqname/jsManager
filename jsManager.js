// Generated by CoffeeScript 1.4.0
(function() {
  var polyfills,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  polyfills = [];

  ng.Resource = (function() {

    function Resource(requirements, complete) {
      this.requirements = requirements;
      this.complete = complete != null ? complete : function() {};
      this.request = __bind(this.request, this);

    }

    Resource.prototype.request = function(target, opts) {
      var self;
      if (target == null) {
        target = window;
      }
      self = this;
      return yepnope({
        load: self.requirements,
        complete: function() {
          try {
            return self.complete.call(target, opts);
          } catch (err) {
            return window.setTimeout(function() {
              return self.complete.call(target, opts);
            }, 500);
          }
        }
      });
    };

    return Resource;

  })();

  (function(ng) {
    if (!ng) {
      ng = {};
    }
    if (!ng.resources) {
      ng.resources = {};
    }
    return $.extend(ng.resources, {
      addThis: new ng.Resource('http://s7.addthis.com/js/250/addthis_widget.js#pubid=ng-dmg'),
      ads: new ng.Resource(["" + STATIC_URL + "js/jq.ads.js"], function(opts) {
        return ng.$(this).ads(opts);
      }),
      carousel: new ng.Resource(["" + STATIC_URL + "js/jq.carousel.js", "" + STATIC_URL + "js/scrollto.js"], function(opts) {
        return ng.$(this).carousel(opts);
      }),
      eCommerce: new ng.Resource(["" + STATIC_URL + "js/jq.carousel.js", "" + STATIC_URL + "js/scrollto.js", "" + STATIC_URL + "js/mustache.js", "" + STATIC_URL + "js/jq.ecommerce.js"], function(opts) {
        return ng.$(this).eCommerce(opts);
      }),
      facebook: new ng.Resource(['//connect.facebook.net/en_US/all.js#xfbml=1&appId=205529552888226']),
      floodlight: new ng.Resource(null, function(opts) {
        return ng.analytics.floodlight.generate(opts);
      }),
      gallery: new ng.Resource(["" + STATIC_URL + "js/jq.gallery.js"], function(opts) {
        return ng.$(this).gallery(opts);
      }),
      lzy: new ng.Resource(null, function(opts) {
        return ng.$(this).attr('src', opts).removeClass('lzy');
      }),
      ngsPlayer: new ng.Resource(["" + STATIC_URL + "js/acudeo.js", "" + STATIC_URL + "js/swfobject.js", "" + STATIC_URL + "js/ngs_player.js"], function(opts) {
        return ng.$(this).ngsPlayer(opts);
      }),
      paginate: new ng.Resource(["" + STATIC_URL + "js/jq.paginate.js"], function(opts) {
        return ng.$(this).paginate(opts);
      }),
      pageScroll: new ng.Resource(["" + STATIC_URL + "js/scrollto.js", "" + STATIC_URL + "js/pageScroll.js"], function(opts) {
        return ng.$(this).pageScroll(opts);
      }),
      quickSearch: new ng.Resource(["" + STATIC_URL + "js/jq.quicksearch.js"], function(opts) {
        return ng.$(this).quicksearch(opts);
      }),
      rssList: new ng.Resource(["" + STATIC_URL + "js/rssList.js"], function(opts) {
        return ng.$(this).rssList(opts);
      }),
      scrollTo: new ng.Resource(["" + STATIC_URL + "js/scrollto.js"], function(opts) {
        return ng.$(this).scrollTo(Array.prototype.shift.call(opts), opts);
      }),
      swfobject: new ng.Resource(["" + STATIC_URL + "js/swfobject.js"], function() {
        return ng.$(document).trigger('swfobjectReady');
      }),
      tabs: new ng.Resource(["" + STATIC_URL + "js/tabs.js"], function(opts) {
        return ng.$(this).tabs(opts);
      }),
      textEntry: new ng.Resource(["" + STATIC_URL + "js/text_entry.js"], function(opts) {
        return ng.$(this).textEntry(opts);
      }),
      toolTip: new ng.Resource(["" + STATIC_URL + "js/tooltip.js"], function(opts) {
        return ng.$(this).toolTips(opts);
      }),
      videoEmbed: new ng.Resource(["" + STATIC_URL + "js/videoEmbed.js"], function(opts) {
        return ng.$(this).videoEmbed(opts);
      })
    });
  })(ng);

  ng.load = function(name, opts) {
    var req, requirements, _i, _len, _results;
    if (ng.$.isArray(name)) {
      requirements = name;
      _results = [];
      for (_i = 0, _len = requirements.length; _i < _len; _i++) {
        req = requirements[_i];
        if ($.isArray(req) && req.length <= 2 && req[0] in ng.resources) {
          _results.push(ng.resources[req[0]].request(this, req[1]));
        }
      }
      return _results;
    } else {
      return ng.resources[name].request(this, opts);
    }
  };

  ng.load([]);

  ng.jsManage = function(context) {
    var $context;
    $context = context ? $(context) : $(document);
    polyfills.push('[data-require]');
    return $context.find("" + (polyfills.join(', '))).each(function() {
      var $this, index, options, parsed_opts, req, requirements, _i, _len;
      $this = $(this);
      if (requirements = $this.data('require')) {
        requirements = requirements.split(/\s*,\s*/);
        options = $this.data('options');
        try {
          parsed_opts = $.parseJSON(options);
          if (parsed_opts === null) {
            parsed_opts = options;
          }
        } catch (error) {
          parsed_opts = options;
        } finally {
          options = parsed_opts;
        }
        if (!$.isArray(options)) {
          options = [options];
        }
        for (index = _i = 0, _len = requirements.length; _i < _len; index = ++_i) {
          req = requirements[index];
          if (req in ng.resources) {
            ng.resources[req].request($this[0], options[index]);
          }
        }
      }
      if ($this.is(polyfills)) {
        return ng.resources[$this[0].nodeName.toLowerCase()].request($this[0]);
      }
    });
  };

  $(document).ready(function() {
    return ng.jsManage();
  });

}).call(this);
