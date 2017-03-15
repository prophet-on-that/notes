# Prototypical Inheritance in JavaScript

This document serves as an introduction or refresher to JavaScript's
prototypical inheritance model, which should be fully understood
before employing inheritance in code.

## Objects and their Prototypes

Objects are pervasive in JavaScript. An object is simply a collection
of key-value pairs, and almost everything is an object. Even functions
are objects. For the purpose of inheritance, all objects have a
reference to another object, called its _prototype_. In the ECMAScript
standard, the prototype of an object _o_ is denoted _o.[[Prototype]]_,
while JavaScript implementations provide a property
`__proto__`. We'll use the former notation here. 

The prototype of an object is an object, and therefore has its own
prototype, which has its own prototype, and so on. In this way objects
and their prototypes form a hierarchy, or _prototype chain_. It's
important to note that the prototype of an object may be `null`,
indicating the end of a prototype chain (`null` is a primitive value
without a prototype). The prototype chain of an object is significant
because, when searching for a property of an object, the entire chain
is searched. If the property is not present in the object, the
prototype will be searched for the property. If the property is not
present in the prototype, its prototype will be searched, and so
on. If a `null` prototype is encountered before the property is found,
the result of the index will be `undefined`.

## Constructor Functions in JavaScript

Object constructors are defined in JavaScript in a manner similar to
the following: 

```javascript
function A () {
    var self = this;
    // ...
}
```

An new 'instance' of `A` is created with the `new` keyword i.e. `var a
= new A ()`. What exactly is the `new` keyword doing, and in what way
does the function `A` correspond to a 'class' in the traditional
object-oriented sense? 

Recall that all functions are objects, and therefore may have
properties. All functions have a property `prototype` (not to be
confused with the function's prototype _[[Prototype]]_) which is an
object that will be the prototype of any 'instance' of the function
i.e. any object created with `new`. By modifying `A.prototype` we are
able to mutate, at runtime, the prototype of all instances of `A`, both
instantiated and not-yet instantiated.

Now we know that the prototype of `a` is `A.prototype`, we may ask how
the prototype chain continues. Recall that `A.prototype` is an object
created when `A` was defined. Such an object has prototype
`Object.prototype`, where `Object` is a function defined in the
JavaScript implementation's standard library. `Object.prototype` is
also the prototype of any object created using literal notation
e.g. `var b = {}`, and has prototype `null`, indicating its intention
as the ancestor of all objects. This object defines functionality
common to all objects, such as the `toString` and `hasOwnProperty`
functions.

The prototype chain for `a` is therefore:

```
a ---> A.prototype ---> Object.prototype ---> null
```

In order to describe the operation of the `new` keyword, it's useful
to introduce the function `Object.create`. This is a function property
of the `Object` function, and is equivalent to a _static method_ in
traditional object-oriented programming. For some object `o`,
`Object.create (o)` returns a new object with prototype `o`.

It's additionally useful to consider the prototype of a function. The
prototype of a function is `Function.prototype`, where `Function` is
again a function defined in the standard library. `Function.prototype`
defines function-specific functionality such as `call`, which executes
the function. As described above, this object's prototype is
`Object.prototype`, so the prototype chain for a function such as `A`
may be visualised as:

```
A ---> Function.prototype ---> Object.prototype ---> null
```

Putting all this together, we may sketch out an implementation of the
`new` keyword:

```javascript
function (constructor, arg0, arg1, ...) {
    var o = Object.create (constructor.prototype);
    
    // Call the constructor with 'o' as 'this'. 
    constructor.call (o, arg0, arg1, ...);
    return o;
}
```

## Constructor Inheritance

Class inheritance in the traditional sense is modelled in JavaScript
with the following pattern:

```javascript
// Create a constructor 'B' whose instances should 'inherit' from 'A'. 
function B () {
    A.call (this);
    var self = this;
    // ...
}

B.prototype = Object.create (A.prototype);
B.prototype.constructor = B;
```

Suppose `var b = new B ()`. By the definition of `Object.create`, the
prototype of `b`, `B.prototype`, is an object whose prototype is
`A.prototype`. `b`'s prototype chain is therefore:

```
b ---> B.prototype ---> A.prototype ---> Object.prototype ---> null
```

In this way, `b` has access to all properties common to all instances
of `A`, in addition to those defined in `B.prototype`. `b` will be
subject to any changes in `A.prototype` in the same way as any
instance of `A`. Properties of `B.prototype` will shadow those of
`A.prototype`, providing a means of _overriding_ function definitions
with behaviour specific to the subclass.

## Resources

* [Inheritance and the Prototype Chain - MDN](https://developer.mozilla.org/en/docs/Web/JavaScript/Inheritance_and_the_prototype_chain)

