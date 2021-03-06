--- 
title: Dependency Inversion
date: 20/04/2010

In object-oriented programming we create a lot of classes. In order for a class to be somewhat useful, it usually needs to communicate with other classes; classes depend on each other to create functionality. This dependency can also be seen as coupling between classes and different parts of our system. High coupling can make a system harder to change, and changes made can ripple through to places you didn’t foresee. Therefore we strive to have as low coupling as possible.

The Dependency Inversion Principle is one form of decoupling as it states:

1. *High-level modules should not depend on low-level modules. Both should depend on abstractions.*
2. *Abstractions should not depend upon details. Details should depend upon abstractions.*

So what does this actually mean? Let’s look at a method in a BlogService.

<script src="http://gist.github.com/508300.js?file=gistfile1.cs"></script>
<noscript><a href="http://gist.github.com/508300">View code</a> </noscript>

The BlogService, being the high-level module, has a dependency on the Repository, the low-level module. (A dependency, by the way, can easily be spotted by looking for the new keyword.)

![Image01](http://thedersen.com/images/dependency-inversion-01.png)

To break this dependency, we are supposed to invert the dependency and make both the Repository and BlogService dependent to an abstraction.

To create the abstraction we introduce an interface called IRepository. In order to make the BlogService depend upon the abstraction, we need to remove the creation of the Repository inside of the BlogService. Instead we inject an IRepository in the constructor when we create a BlogService instance. This way the BlogService is decoupled from the Repository, and it does not really care what repository it gets, as long as it implements the IRepository.

<script src="http://gist.github.com/508300.js?file=gistfile2.cs"></script>
<noscript><a href="http://gist.github.com/508300">View code</a> </noscript>

To make the Repository depend on an abstraction and make it useful for the BlogService, it simply needs to implement the IRepository interface.

<script src="http://gist.github.com/508300.js?file=gistfile3.cs"></script>
<noscript><a href="http://gist.github.com/508300">View code</a> </noscript>

The dependency between BlogService and Repository is now removed and both depends upon an abstraction; the IRepository. Both classes can easily be changed, and even replaced without affecting each other.

![Image02](http://thedersen.com/images/dependency-inversion-02.png)

## Who “owns” the abstraction?

Let's say the BlogService belongs in the Domain or Business Layer and the Repository belongs in the Persistence or Data Access Layer. Before we introduced DI this made the Domain Layer depend upon the Persistence Layer. To invert this dependency we should make the Persistence Layer dependent on the Domain Layer. Therefore the IRepository belongs in the Domain Layer.