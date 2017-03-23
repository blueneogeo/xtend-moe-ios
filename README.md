# Xtend MOE iOS

Some handy tools for using Xtend with the [Multi-OS-Engine](https://multi-os-engine.org).

## Getting Started

This project is not on Maven yet. A [copy of the built jar](https://github.com/blueneogeo/xtend-moe-ios/blob/master/xtend-moe-ios-1.0.jar) is in the root.

You can also build the jar yourself:

** gradle build - creates the jar in ./build/libs

## Creating and extending NSObject based classes

The **@Alloc** and **@Init** Active Annotations let you extend NSObject classes like this:

```xtend

@Alloc @Init
class MyViewController extends UIViewController {

}

```

And to use this view controller: 

```xtend
val myController = MyViewController.alloc.init
```

## @Alloc

To initialize any NSObject, you need to define a static **alloc()** method, as well as a **protected new(Pointer)** method. **@Alloc** does this for you. The **@Alloc** Active Annotation adds the following code to your class:

```xtend
protected new(Pointer peer) {
	super(peer)
}

@Selector("alloc")
def static native MyController alloc()
```

*[@Alloc source code](https://github.com/blueneogeo/xtend-moe-ios/blob/master/src/main/java/xtend/moe/ios/annotations/Alloc.xtend)*

## @Init

To initialize an **NSObject**, first call **alloc()** and then one of the **init()** methods in Objective C. This means you need to create this **init()** method as well. **@Init** does this for you, adding this code:

```xtend
@Selector("init")
def native MyController init()
```

*[@Init source code](https://github.com/blueneogeo/xtend-moe-ios/blob/master/src/main/java/xtend/moe/ios/annotations/Init.xtend)*

## @NSConstructor

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

The **@NSController** annotation lets you convert a normal method into a constructor. Any method annotated with **@NSConstructor** will be changed as follows:

- it is made static
- it will return an instance of the class
- when statically called, it will call the init and alloc methods, and then execute your own constructor code

These constructor methods can have any normal Java method name, and you can create multiple on a single class.

*[@NSConstructor source code](https://github.com/blueneogeo/xtend-moe-ios/blob/master/src/main/java/xtend/moe/ios/annotations/NSConstructor.xtend)*
