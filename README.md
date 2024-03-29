jsManager
=========

An unobtrusive javascript resource manager.


***ABOUT***

JSManager can be thought of as a package manager of sorts. It maintains and/or accepts list 
of "registered" functions, operations, scripts, stylesheets and polyfills packaged in a requirement 
bundle reffered to as a "named resource collection".

The goal is to provide a method for maintaining a loose coupling of a modules markup, functionality and style.


***WHY***

Seriously? Another resource manager? Seriously?

Well, as with so many things, individual projects present slightly different challenges and goals. 
In this case, the requirements of the project called for several different modules on a variety of pages, each
with specific functionality and/or styles. This method allows us to build modularly and keep the markup, functionality
and style loosely coupled. If you find yourself with similar needs. This might be worth a look. Maybe even a 
contribution or two to the code.

***USAGE***

Components notify jsManager of requirements via HTML `data-` parameters. The two parameters of 
concern are `data-require` and `data-options`.

```html
<div class="my_awesome_module" data-require="awesome_module" data-options='[{"some_option": 5, "some_other_option": "a_value"}]'>
...
</div>
```


**DATA-REQUIRE**

A comma separated list of named resource collections. These collections should be independent of 
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
      `path/to/resource` is, well, the path to your resource,
      `options` is the JSON object constructed in your component's `data-options` attribute
  and `doStuff` is a function to perform upon completion of the loading of all resources for the requirement.

Construction of a Named Resource Collection DOES NOT mean those resources will be loaded to the page, merely 
that they CAN be. To load the resources, the appropriate handles need to be in a `data-require` attribute 
somewhere in the DOM.
