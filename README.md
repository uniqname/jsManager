jsManager
=========

An unobtrusive javascript resource manager.


***ABOUT***

JSManager maintains a white list of "registered" functions, operations and polyfills


***USAGE***

Components notify jsManager of required resources via HTML `data-` parameters. The two parameters of concern are `data-require` and `data-options`.


**DATA-REQUIRE**

A comma separated list of named resource collections. 
These collections should be independant of each other. 

Dependant resources are contained within a named resource collection
After all resources have been loaded a single callback is fired 
initializing the resource collection. This callback 


**DATA-OPTIONS**

A JSON object (or array of objects) which represent any optional 
parameters the resource collection may need after all resources
have been loaded.

Plugins that take more than one parameter should have an 
array of parameters as their data-options attribute.
If only one parameter is needed, the data-options attibute 
does not need to be wrapped in an array
