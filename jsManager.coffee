# ng.JSManager
# Author: Cory Brown for National Geographic
#         gits and tweets under @uniqname

# ABOUT
#   JSManager maintains a white list of "registered" functions, operations and
#   polyfills

# USAGE
#   Components notify jsManager of required resources via HTML "data-" parameters.
#   The two parameters of concern are "data-require" and "data-options".

#   DATA-REQUIRE
#       A comma separated list of named resource collections. 
#       These collections should be independant of each other. 

#       Dependant resources are contained within a named resource collection
#       After all resources have been loaded a single callback is fired 
#       initializing the resource collection. This callback 

#   DATA-OPTIONS
#       A JSON object (or array of objects) which represent any optional 
#       parameters the resource collection may need after all resources
#       have been loaded.

#       Plugins that take more than one parameter should have an 
#       array of parameters as their data-options attribute.
#       If only one parameter is needed, the data-options attibute 
#       does not need to be wrapped in an array

polyfills = [
    #registered polyfils for elements
]
# The Resource object takes a path to the resource and a function that will be
# fired once that resource has been loded.
class ng.Resource

    constructor: (@requirements, @complete= -> ) ->

    request: (target=window, opts) =>
        self = this
        yepnope
            load: self.requirements

            complete: ->
                try 
                    self.complete.call target, opts
                catch err
                    window.setTimeout ->
                        self.complete.call target, opts
                    , 500
( (ng) ->
    ng = {} if not ng
    ng.resources = {} if not ng.resources

    $.extend ng.resources,
        addThis : new ng.Resource 'http://s7.addthis.com/js/250/addthis_widget.js#pubid=ng-dmg'

        ads : new ng.Resource(["#{ STATIC_URL }js/jq.ads.js"],
            (opts) ->
                ng.$(this).ads opts)

        carousel: new ng.Resource([
            "#{ STATIC_URL }js/jq.carousel.js"
            "#{ STATIC_URL }js/scrollto.js"
            ], (opts) ->
            ng.$(this).carousel opts)

        eCommerce : new ng.Resource([
            "#{ STATIC_URL }js/jq.carousel.js"
            "#{ STATIC_URL }js/scrollto.js"
            "#{ STATIC_URL }js/mustache.js"
            "#{ STATIC_URL }js/jq.ecommerce.js"
            ], (opts) ->
                ng.$(this).eCommerce(opts))

        
        facebook: new ng.Resource(['//connect.facebook.net/en_US/all.js#xfbml=1&appId=205529552888226'])
        
        floodlight: new ng.Resource(null, (opts) ->
            ng.analytics.floodlight.generate(opts))
        
        gallery: new ng.Resource(["#{ STATIC_URL }js/jq.gallery.js"], (opts) ->
            #resource initialization
            ng.$(this).gallery opts)

        lzy: new ng.Resource(null, (opts) ->
            ng.$(this).attr('src', opts).removeClass 'lzy')

        ngsPlayer : new ng.Resource([
                "#{ STATIC_URL }js/acudeo.js",
                "#{ STATIC_URL }js/swfobject.js",
                "#{ STATIC_URL }js/ngs_player.js"
            ], (opts) ->
                ng.$(this).ngsPlayer opts)

        paginate: new ng.Resource(["#{ STATIC_URL }js/jq.paginate.js"], (opts) ->
            ng.$(this).paginate opts)

        pageScroll: new ng.Resource([
                "#{ STATIC_URL }js/scrollto.js",
                "#{ STATIC_URL }js/pageScroll.js"
            ], (opts) ->
                ng.$(this).pageScroll opts)

        quickSearch: new ng.Resource(["#{ STATIC_URL }js/jq.quicksearch.js"], (opts) ->
            ng.$(this).quicksearch(opts))

        rssList: new ng.Resource(["#{ STATIC_URL }js/rssList.js"], (opts) ->
            ng.$(this).rssList(opts))

        scrollTo: new ng.Resource(["#{ STATIC_URL }js/scrollto.js"], (opts) ->
                ng.$(this).scrollTo Array.prototype.shift.call(opts), opts)

        swfobject: new ng.Resource([
                "#{ STATIC_URL }js/swfobject.js"
            ], ->
                ng.$(document).trigger 'swfobjectReady')

        tabs: new ng.Resource(["#{ STATIC_URL }js/tabs.js"], (opts) ->
            ng.$(this).tabs(opts))

        textEntry: new ng.Resource(["#{ STATIC_URL }js/text_entry.js"], (opts) ->
            ng.$(this).textEntry opts)

        toolTip: new ng.Resource(["#{ STATIC_URL }js/tooltip.js"], (opts) ->
            ng.$(this).toolTips(opts))

        videoEmbed: new ng.Resource(["#{ STATIC_URL }js/videoEmbed.js"], (opts) ->
            ng.$(this).videoEmbed(opts))
)(ng)

ng.load = (name, opts) ->
    if ng.$.isArray name
        requirements = name 
        ng.resources[req[0]].request this, req[1] for req in requirements when $.isArray(req) and req.length <= 2 and req[0] of ng.resources
    else 
        ng.resources[name].request this, opts

#Always load
ng.load [
#   [name, opts]
    # 'addThis'
    # 'facebook'
]
ng.jsManage = (context)->
    $context = if context then $(context) else $(document)
    polyfills.push '[data-require]'
    $context.find("#{ polyfills.join(', ') }").each ->
        $this = $ this

        if requirements = $this.data 'require' #Assignment is intentional
            requirements = requirements.split /\s*,\s*/
            options = $this.data 'options'

            # jQuery has trouble recognizing a JSON array when pulling from a data attr.
            try
                parsed_opts = $.parseJSON options
                parsed_opts = options if parsed_opts is null # parsing a js object as JSON returns null
            catch error
                parsed_opts = options
            finally 
                options = parsed_opts
            options = [options] if not $.isArray options

            ng.resources[req].request $this[0], options[index] for req, index in requirements when req of ng.resources

        if $this.is polyfills
            ng.resources[$this[0].nodeName.toLowerCase()].request $this[0]
$(document).ready ->  
    ng.jsManage()