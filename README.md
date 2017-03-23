# Xtend MOE iOS

Some handy tools for using Xtend with the [Multi-OS-Engine](https://multi-os-engine.org).

## Getting Started

This project is not on Mavan yet. A copy of the built jar is in the root.

You can also build the jar yourself. It is built on using Gradle:

* gradle build - creates the jar in ./build/libs

## Creating and extending NSObject based classes

The @Alloc @Init and @NSConstructor Active Annotations let you extend NSObject classes like this:

```xtend

@Alloc @Init
class MyViewController extends UIViewController {

	@Accessors String name

	@NSController
	def create(String name) {
		this.name = name
	}

}

```

And to use this view controller: 

```xtend
val myController = MyViewController.create('Hello world')
```

## @Alloc

To initialize any NSObject, you need to define a static alloc() method, as well as a protected new(Pointer) method. @Alloc does this for you. The @Alloc Active Annotation adds the following code to your class:

```xtend
protected new(Pointer peer) {
	super(peer)
}

@Selector("alloc")
def static native MyController alloc()
```

## @Init

To initialize an NSObject, first call alloc() and then one of the init() methods in Objective C. This means you need to create this init() method as well. @Init does this for you, adding this code:

```xtend
@Selector("init")
def native MyController init()
```

## @NSConstructo

Xtend MOE iOS provides you with Active Annotations that create this code for you and help you write nicer constructors:

```xtend
val myController = MyViewController.create('Hello world')
```

To do this, annotate the above class like this:

```xtend

@Alloc @Init
class MyViewController extends UIViewController {

	@Accessors String name

	@NSController
	def create(String name) {
		this.name = name
	}

}

```

The @Alloc annotation creates the pointer constructor and the allow method. 
The @Init methid creates the init method.

The @NSController method lets you convert a normal method into a constructor. Any method annotated with @NSConstructor will be changed as follows:

- it is made static
- it will return an instance of the class
- when statically called, it will call the init and alloc methods, and then execute your own constructor code

These constructor methods can have any normal Java method name, and you can create multiple on a single class.
