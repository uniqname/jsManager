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
        # package: new ng.Resource('path/to/resource.js', 'path/to/resource.css', ->
        #   callback()
        #)
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
