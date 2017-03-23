# Xtend MOE iOS

Some handy tools for using Xtend with the [Multi-OS-Engine](https://multi-os-engine.org).

## Getting Started

This project is not on Mavan yet. A copy of the built jar is in the root.

You can also build the jar yourself. It is built on using Gradle:

* gradle build - creates the jar in ./build/libs

## Creating and extending NSObject based classes

To extend an NSObject in MOE, you have to implement the alloc() and init() methods, as well as add the constructor for the peer Pointer. For example:

```xtend

class MyViewController extends UIViewController {

	@Accessors String name

	protected new(Pointer peer) {
		super(peer)
    	}

	@Selector("alloc")
	def static native MyController alloc()
	
	@Selector("init")
	def native MyController init()

}

```

Besides this, this code is not very Java-friendly to use, even if Xtend makes it a lot easier than Java:

```xtend

val myController = MyViewController.init.alloc => [ name = 'Hello world' ]

```

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

The @Alloc annotation creates the pointer constructor and the allow method. The @Init methid creates the init method.

The @NSController method lets you convert a normal method into a constructor. Any method annotated with @NSConstructor will be changed as follows:

- it is made static
- it will return an instance of the class
- when statically called, it will call the init and alloc methods, and then execute your own constructor code

These constructor methods can have any normal Java method name, and you can create multiple on a single class.
