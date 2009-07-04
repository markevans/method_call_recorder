Method call recorder
===================
A method call recorder is an object on which you can call any method, with any arguments (and continue doing so on child objects).

    rec = MethodCallRecorder.new
    rec[:this].is(:a, 'nice')[:little, :object].isnt.it?  # This does very little, but it works!
    
You can then play methods back on other objects.

    rec[1].upcase   # first record the method chain
    rec._play(['hello','there']) # => 'THERE'
    
You can also inspect the method chain if you wish (shows all methods called including arguments). This is an array of `MethodCall` objects.
Using the last example:

    method_call = rec._method_chain.first
    method_call.method  #  :[] (a symbol representing the method call)
    method_call.args    #  [1] (an array of the args)

You can reset the recorded method chain using

    rec._reset!

For a few methods, see the specs (sorry!)

Install
-------
Install from github gems in usual way

Copyright
--------
Copyright (c) 2009 Mark Evans. See LICENSE for details.
