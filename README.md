puppet_functions
================

This module contains custom functions for puppet in addition to the stdlib functions.

# Compatibility #

The puppet_functions module has only been tested against puppet 3.3.2.

# Functions #

create_path
---
Takes a string containing a fully qualified path and ensures that the
directory specified **and** all parent directories exist.  Any special
permissions and/or attributes may be specified in an override.

This example creates '/tmp/create_path/testing123' and ensures that the
'/tmp/create_path' directory is owned by the 'puppet' user:

  create_path('/tmp/create_path/testing123')

  File['/tmp/create_path'] {
    owner => 'puppet',
  }

- *Type*: rvalue

As an aside, the "official" way in Puppet to ensure a directory and all it's 
parents are created is to create an array of parents and the final directory 
and pass that to the File resource type.
            
  example ('official' method):
                    
    we want to ensure that /foo/bar/baz exists

    $dirs = ['/foo', '/foo/bar', '/foo/bar/baz']
    file { $dirs:
      ensure => directory,
    }

This works ok... if you know the directory structure at the time you are 
writing the manifest.  If you get the directory from hiera, there is no
decent way to iterate through the string to create the array.

This function is modeled off the stdlib module and, in fact, depends on the 
stdlib module.  Internally, it takes the path, breaks it up into an array 
similar to the example above, checks each item in the array to see if it has 
already been added to the catalog, and finally, if it hasn't been added to the 
catalog, create the File resource and add it to the catalog.


