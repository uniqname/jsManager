jsManager
=========

An unobtrusive javascript resource manager.


***ABOUT***

JSManager can be thought of as a package manager of sorts. It maintains and/or accepts list 
of "registered" functions, operations, scripts, stylesheets and polyfills packaged in a requirement 
bundle reffered to as a "named resource collection".


***USAGE***

Components notify jsManager of requirements via HTML `data-` parameters. The two parameters of 
concern are `data-require` and `data-options`.


**DATA-REQUIRE**

A comma separated list of named resource collections. These collections should be independant of 
each other and may have overlapping resources. jsManager ensures that the resourse is only 
loaded once.

Dependant resources are contained within a named resource collection. After all resources have been 
loaded a single callback is fired initializing the resource collection. This callback is passed to
the named resouce collection constuctor.


**DATA-OPTIONS**

A JSON object (or array of objects) which represent any optional 
parameters the resource collection may need after all resources
have been loaded.

Plugins that take more than one parameter should have an 
array of parameters as their data-options attribute.
If only one parameter is needed, the data-options attibute 
does not need to be wrapped in an array.


**Constructing a Named Resource Collection**

A Named Resource Collection takes the following form.
```javascript
myNewNRC = ng.Resource(['path/to/resource.js',
                        'path/to/resource.css'],
                         function (options) {
                            doStuff(options);
                      });
```

Where `myNewNRC` is the handle for your Named Resource Collection,
      `path/to/resource` is a, well, the path to your resource,
      `options` is the JSON object constructed in your component's `data-options` attribute
  and `doStuff` is a function to perform upon completion of the loading of all resources for the requirement.
