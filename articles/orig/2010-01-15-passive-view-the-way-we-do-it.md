--- 
title: Passive View the way we do it
date: 15/01/2010

At [work](http://infodoc.no/) we do a lot of Windows Forms development. To ease unit testing and apply better [separation of concerns](http://en.wikipedia.org/wiki/Separation_of_concerns) our UI is built using the [Passive View](http://martinfowler.com/eaaDev/PassiveScreen.html) pattern, a variant of the Model View Presenter pattern. Using this pattern we can test the presenter in total isolation from the UI by [mocking](http://en.wikipedia.org/wiki/Mock_object) the view. Since the view contains no logic we run a very little risk by not testing it.

We do a presenter first approach. This means that the presenter is created/loaded first, then it is asked to give you a UI that can be shown on the screen.

## The Presenter

The interface implemented by all presenters looks something like this:
	
<script src="http://gist.github.com/508315.js?file=gistfile1.cs"></script>
<noscript><a href="http://gist.github.com/508315">View code</a> </noscript>
	
The initialize method is called whenever the presenter is constructed. The UI property returns the view. The reason that it is of type object, is that then there is no need to reference System.Windows.Forms in the presenter library. This is not crucial as long as you keep UI elements out of the presenters since they are not very unit test friendly.

Instead of the presenters implementing IPresenter directly, we create a specific interface that inherits IPresenter for each presenter. This interface is usually empty.

<script src="http://gist.github.com/508315.js?file=gistfile2.cs"></script>
<noscript><a href="http://gist.github.com/508315">View code</a> </noscript>

In addition, the presenter must implement a callback interface. The view knows nothing about the presenter itself. Instead it gets a reference to this interface which contains one method for each operation that can be performed on the view plus one for each event that can be raised by a control in the view. Needless to say, we don’t create a method for all events, only the ones we need to respond on.

<script src="http://gist.github.com/508315.js?file=gistfile3.cs"></script>
<noscript><a href="http://gist.github.com/508315">View code</a> </noscript>

As you may have noticed, both methods on this interface is declared without any parameters and returns void. This is important, otherwise presentation logic might leaking into the view. The presenter always asks the view when it needs information, the view never tells the presenter anything, thus parameter less. Instead of the presenter returning something to the view, it explicitly sets a property or several on the view, thus void. This is actually what makes the view passive – the presenter is doing all the work.

Enough abstractions, let’s move on to the actual implementation of the presenter.

<script src="http://gist.github.com/508315.js?file=gistfile4.cs"></script>
<noscript><a href="http://gist.github.com/508315">View code</a> </noscript>

Nothing magic going on here. As you can see the presenter implements both the IMyPresenter interface as well as the IMyPresenterCallbacks and it gets an instance of an IMyView injected in the constructor, which again can be retrieved form the UI property.

Attaching the presenter to the view so that they can communicate with each other is done on line 17 in the initialize method. Here we also set the default or initial state of the view.

The callback methods doesn’t do much in this example other then enabling/disabling the save button when the text is changed. Just notice that the presenter asks the view for the MyText property, and then tells the view to enable/disable its save button based on whether or not the MyText property is empty. Since this logic is moved from the view into the presenter, we can actually have unit tests that verify this behavior. Cool, or what?

So, how does the callback methods gets invoked? To find out we need to take a look at how the view is implemented.

## The View

The base interface for all view looks like this:

<script src="http://gist.github.com/508315.js?file=gistfile5.cs"></script>
<noscript><a href="http://gist.github.com/508315">View code</a> </noscript>

A simple generic interface with one method used by the presenter to attach itself. The TCallbacks type parameter is the type of the callbacks interface that the presenter implements. In this example; IMyPresenterCallbacks.

As you saw, MyPresenter got an instance of an IMyView. This is the interface specific to one view and it contains properties for all input fields such as text boxes, check boxes, drop downs etc., labels and state properties of the controls.

<script src="http://gist.github.com/508315.js?file=gistfile6.cs"></script>
<noscript><a href="http://gist.github.com/508315">View code</a> </noscript>

Finally, we’ll look at how the view is implemented.

<script src="http://gist.github.com/508315.js?file=gistfile7.cs"></script>
<noscript><a href="http://gist.github.com/508315">View code</a> </noscript>
	
This class is a simple Windows Forms form or control implementing the IMyView interface. The properties on the interface is basically just wrapping the properties of the controls, and does not do anything else. Remember that any logic is in the presenter.

Attaching the presenter to the view enabling the presenter to react on events generated by the view is done in the attach method, which you saw the presenter called when it was initialized. On line 8 the Click event of the save button is attached to the OnSave method on the presenters callback interface and on line 9 the TextChanged event of the text box is attached to the OnMyTextChanged method. Here we do this using a [lambda expression](http://msdn.microsoft.com/en-us/library/bb397687.aspx), keeping things nice and simple I think, but it can of course be done using normal event/delegate syntax. When the events are hooked up, the callback methods on the presenter gets called whenever one of these events is raised. And that’s about it.

## Summary

At first this might look a bit overwhelming. Creating three interfaces, one presenter and one view just to get something to show up on the screen can seem costly, but I think the benefits outweighs the cost. After all it does not take many minutes creating these interfaces and classes.

First of all using this approach it makes almost everything testable. There is not much logic left in the view that are not tested. Secondly, since it introduces separation between the view and the presentation logic they can be developed separately by different developers and/or designers as long as the contracts (IMyView and IMyPresenterCallbacks) are implemented first.