# Cell Configuration

V from `$CLIENT` pointed out the modern cell configuration stuff

IDEARS
  - simple tableview with one of these
  - simple collection view with one of these
  - custom view that uses a configuration
  - Updating existing cell with a new configuration
  - updating stuff inside an animation and getting animations for free
  - play with color transformers. Robots in the skies
  - play with reserved layout size
  - look at the different UI*Configuration thingies available
  - UIListContentView in our own custom views
  - custom configuration in a table view - can I see the flow of state changes?
  - The two biteinteractive approaches to plumbing a switch through
    - and try it via diffable data sources
  - And with combine as the conduit?
  - something more complicated

other link(s):
* https://www.biteinteractive.com/cell-content-configuration-in-ios-14/
* https://www.biteinteractive.com/user-interactive-cell-configurations-in-ios-14/
* Apple doc link from V: https://developer.apple.com/documentation/uikit/uicollectionviewcell/3600949-contentconfiguration
* https://swiftsenpai.com/development/uicollectionview-list-custom-cell/

Questions from Mikey
* Does that supplant cell viewmodels? Are they cell viewmodels?

==================================================
# Stuffs

* [ ] UIContentConfiguration - object that produces a content view
      - makeContentView: UIContentView
      - updatedConfigurationForState(UIConfigurationState) -> instancetype
* [ ] UIContentView - view with a settable property that is a content configuration
      - id configuration
* [ ] UIConfigurationState 
      - initWithTraitCollection / traitCollection accessor
      - customStateForKey:
      - setCustomState:forKey
      - objectForKeyedSubscript
* [ ] UIListContentConfiguration
      - and all the various properties
* [ ] UIAction (not related this, but an example uses this. Also new in iOS 14)

==================================================

# WWDC 2020 10027

* WWDC 2020 session 10027:https://developer.apple.com/videos/play/wwdc2020/10027

Modern Cell Configuration

iOS 14 - bringing brand new features to collection view by building on three foundational technologies.
See "advances in collection view" session for intro to these features.

* how populate the data
    - Section snapshots
    - Diffable Data Source

* how you define layout
    - List Configuration
    - Compositional Layout

* and how you display the content (presentation)
    - List Cell, View Configuration
    - Cell

This is View Configuration - new API to configure the content and styling of our cells.

* Start with basics -  how to use to set up our cells
* Next an new concept called Configuration State, works with configurations to make it easy to get 
  different appearances for different states
* Finally a closer look at the two configuration types
    - background configurations
    - content configurations

Before get into the these modern cell configuration APIs, let's look at an example of the old sucky way.
How a table view cell in iOS 13.

using built-in imageview and textlabel on tableview cell to display an image and some text.

```
let cell: UITableViewCell = ...
// use the built-in imageview and textlabel to display content
cel.imageView?.image = UIImage(systemName: "borgle")
cell.textLabel?.text = "Blah"
```

This is a simple example of what we mean by "cell configuration"

Let's take a look doing the same thing using the new configuration APIs

```
let cell: UITableViewCell = ...
var content = cell.defaultContentConfiguration()
content.image = UIImage(systemName: "splorfle")
content.test = "Blah blah"
cell.contentConfiguration = content
```

This is how you configure a cell using a _content configuration_. Looks similar to before, but
with two new lines of code


```
var content = cell.defaultContentConfiguration()
```

The first thing we do is ask the cell for a default content configuration.  This always returns
a fresh configuration without any content set on it.  This configuration *does* have default
styling based on the cell and tableview style.

Will talk more about styling and other features of content configurations soon

set image and text on the content configuration

```
content.image = UIImage(systemName: "splorfle")
content.test = "Blah blah"
```

This should feel familiar.

Now set up the content, one final step. Apply the content to the cell

```
cell.contentConfiguration = content
```

As soon as we do this, the cell is updated to display the image and text we specified.

Before, setting the image and text only changed our local copy of the configuration. b/c using
a content configuration, we never _directly_ touch a UIImageView or a label.  All of the
properties are set on the configuration itself.  **NICE**

What do we gain by using the content configuration?

* the code to configure a tableview cell is actually the same code you would use to configure
  any cell, like a collection viewcell.
  - the same code works for anything that support content content configuration, like tableview headers and
    footers

This works b/c configurations are composable. Instead of all of the functionality being baked into the
cell class itself like UITableViewCell - these standard cell layouts and appearances are available as
independent pieces that can plug into any cell or view that supports them

Let's run this code to see how it looks and learn what other benefits we get from using configurations.

(collection view lest in the new sidebar appearance for multi-column ipad apps)  Can see the cell has the
blorf image and text.  Things get more interesting when start to interact with the cell.

When touch down on the cell, shows highlighted appearance.  Lift up, the cell becomes selected.

These are just a couple of the states the cell can be in.

@4:50 - add a bunch and do different states.  @5:09 has the states
* Normal
* Highlighted
* Selected
* Highlighted and selected
* disabled
* Disabled and selected
* Drop Targét

The default styling for a sidebar list cell varies significantly in different states. By using configurations
to set up the cells, we get all of these appearances automatically

We've gotten a taste of these new configurations - what are they exactly?

A _configuration_ describes appearance of a view for a specific state. 

Things like the content, styling, metrics, and behavior.

By itself, a configuration is just a bunch of properties. It doesn't do anything until you _apply_ to a
view or a cell to render.

Configurations are composable. They can be used with any type of cell or view that supports them.

There are two types of configurations.

* background
* content

Features that they provide

* Background Configuration
  - background (fill) color
  - visual effect (e.g. blur)
  - stroke
  - insets and corner radius
  - custom view
    - for something more custom by providing your own view

The standard layout for cells, headers and footers, like tableview styles we have today.

* List Content Configuration
  - image
  - text
  - secondary text
  - layout metrics and behaviors

list content configurations are even more powerful. They support an image, text, and secondary text,
and expose many properties for you to customize for each of those.

Also offer higher level behaviors, like flexible layouts to display larger amounts of text, and special
layout modes for accessibility text sizes (NICE)

These two configuration types go hand-in-hand and have common design principles.

* inexpensive to create
  - they're lightweight.  They are value types in Swift - so it's yours alone, and changes you make to
    it don't affect anything else until you set that configuration to the cell.
* always start with a fresh configuration, like asking the cell for its default content configuration.
  - not applies the first time configuring the cell, but also whenever you want to update a cell that has
    already been configured. Each time, start with a fresh configuration and set it up for the new state

You don't need to think about the old state - UIKit efficiently updates views as needed.  Don't worry if
an old configuration was applied, and don't try to get the existing configuration first to make changes to
it. (NICE - avoids using UI as data storage)

If been using UIKit for a long time, this might feel a different at first.  But once you start thinking
this way, it's incredibly liberating.   When you apply a configuration to the cell, UI kit will do all of the
heavy lifting for you - it will figure out what's changed and efficiently update the views as needed.

As you saw when ran the code earlier, configurations give default appearance for different states.
Configurations are also built on top of robust infrastructure you can use to customize their appearance.

You also advanced behaviors in a a couple  of lines of code.

get automatic animations and transitions, so say you want to animate the change to your background
apperance, all you have to do is set a new background configuration inside an animation.

configurations aren't just easy to use. they're design actually eliminates entire classes of bugs (yay),
especially when dealing with complex states and transitions.  You always know that the currently
applied configuration is the Truth, and when you set a new configuration, that new one is applied all
at once

Finally configurations are built from the ground up for performance, especially important to ensure smooth
scrolling.  b/c UIKit is responsible for managing views and rendering, we're able to implement many internal
performance optimizations under the hood.

Now familiar with basics, let's talk about a new concept that works together with them.  **Configuration State**

Configuration State represents the various inputs to configure your cells and views.

What kind of inputs?  (scatter word cloud)
  - traits (UITraitCollection)
    - content size category
    - user interface idiom
    - size class
    - user interface style
    - layout direction

  - States
    - swiped
    - selected
    - lifting (?)
    - highlighted
    - disabled
    - editing
    - dragging
    - focused
    - expanded
    - drop target

Maybe your cell is selected. or is a target for dragon-drop. Or maybe it's temporarily disabled.  
These are just some of the different states that are common in UIKit.

- on top of these states, your app has its own custom state
  - archived
  - flagged
  - view model
  - completed
  - primary
  - shared
  - processed

These are all the different pieces of state you use that are specific to your app and your domain.

e.g. when configuring cells, a messaging app might need to know whether a message is archived or flagged.
And a payment app might show which transactions are processed.  

If you use a view model to populate your cells with content, can think of that viewmodel as a custom
state as well.  All of these things make up Configuration State - a collection of all the traits, states,
and your own custom states, wrapped together in one place.

@11:50 Where do you find a configuration state?  

Each cell, header, and footer in collection/table view has its own configuration state.

```
+---------------+
| List          |
+---------------+
|  +---------+  |
|  | Header  |----> [ View Configuration State ]
|  +---------+  |
|  +---------+  |
|  | Cell    |----> [ Cell Configuration State ]
|  +---------+  |
|  +---------+  |
|  | Cell    |----> [ Cell Configuration State ]
|  +---------+  |
+---------------+
```

There are two cells, and each one have different things in its configuration state.

What does it look like?

Two types:

* View Configuration State
    - like the header
* Cell Configuration State

@12:24 View Configuration State.

Starts with Trait Collection, and four states (highlighted/selected/disabled/focused - simple bools), and
optional custom states - key-value storage for you to add any extra state or data that you want to use
when configuring your view.

@12:50 Cell Configuration State

Takes everything from view configuration state, and adds things specific for cells (editing/swiped/expanded/fewmits)

@13:10 Updating Configuration

one of the most things is to use it update configurations for new states. You can ask any background or
content configuration to return an updated version of itself for a different configuration state.
This will return a new copy of the configuration with its properties updated to reflect the new state.

```
let updatedConfiguration = configuration.updated(for: state)
```

_(from the diagram, looks like the `updated` returns a new updated configuration based on the particulars
of the given configuration state)_

example - a background configuration might change its background color, and a content configuration might
change the image tint color and text color.

When you ask for an updated configuration, the original configuration doesn't change (value type after all),
and if customized properties on the original configuration, those properties will remain the same on the
updated configuration.  Can think of the properties on a configuration as becoming locked once you set
them

@14:06 - recall the demo earlier - saw the content configuration updating its appearance for different states.
that worked by _automatic configuration updates_

```
var automaticallyUpdatesContentConfiguration: Bool
var automaticallyUpdatesBackgroundConfiguration: Bool
```

by default, when you set a background or content configuration on the cell, any time the cell's 
_configuration state_ changes, it will automatically ask the configuration to return an updated version of itself,
and then re-apply that new configuration back to the cell.

These (two) properties let you control this behavior.

Automatic update are great to get the default styling for each state, but if you want to customize the
apperance for different states. you can disable auto updated, and update the configurations yourself instead

Where should you put your code that updates these configurations

New `updateConfiguration(using state: UICellConfigurationState)` on table and collectionview cells. Override
in cell subclass - put your code to configure your cell based on the state that's passed in.

It's always called before cell first displays, and called again the configuration state may have changed,
so you can configure yourself for your new state.

When using configurations, you don't need to worry about the old state. Just get a fresh configuration
each time, set properties, and apply it to your cell.

Configurations work best when there's a single place in your code that handles setting them up and
applying to your cell.  If you're using a custom cell subclass, this new method is the best place to
do that.

This method is also a great place to centralize any other setup or updates to your cell.

e.g. if using the new collection view list cell, you can use this method to update the tint color of
your cell accessories for different states.

If you need to to reconfigure, call `setNeedsUpdateConfiguration()`

@16:32 example of how to use

```
override func updateConfiguration(using state: UICellConfigurationState) {
    var content = self.defaultConfiguration().updated(for: state)

    content.image = self.item.icon
    content.text = self.item.title

    if state.isHighlighted || state.isSelected {
        content.imageProperties.tintColor = .white
        content.textProperties.color = .white
    } // otherwise use configuration's default colors

    self.contentConfiguration = content
}        
```

And that's it! This will get called when the state changes.

This is how you customize the content configurations appearance for different states. We could similarly
customize the background configuration as well.

@17:50 different way to change colors, called a Color Transformer.

Color transformer takes in one color and returns a different color by modifying the original color in
some way.

e.g. have a color transformer that returns a grayscale version of the color.  It's just a simple
function.  But they're very powerful, can produce many different variants from the same input color
with.

Some of the default configurations for certain styles and states will have a pre-set color transformer,
in order to produce a specific appearance for that state.  It combines with the input color to produce the
color you see.

Now how configurations produce updated appearances for different states, let's cover some of the details when using
background content configurations

@19:03

Collectionview list cells, tableview cells, and tableview headers/foots all set up a default background
configuration automatically, based on the style of the containing list or tableview. typically won't
need to do anything at all to get the background appearance you want.

content configurations work a little differently.  Instead of the cell automatically applying one by
default, you can use the defaultContentConfiguration() on the cell to get a fresh configuration based
on the cell's style - as you seen in the earlier examples

But for both background and content configurations, can easily request the default configuration for
any style that you like

e.g.
```
var background = UIBackgroundConfiguration.listSidebarCell()
var content = UIListContentConfiguration.sidebarCell()
```

@20:12 Take a look at some of these different styles in action.

A list of sticker categories (image - label) - configured with the sidebar appearance. All the cells have
default background and content configurations that match that style.

@20:32 can see the cells update themselves when interacting with them.

The sidebar style is just one of the appearances for collection view list.

@20:50 - what happens if configure with different appearances, with the grouped appearance, followed by
inset group, followed by plain (standard UITableView style).

Collection view list support new files, the sidebar-plain, and the original sidebars

All of the visual styling that you see for these different list appearances is coming the default
background and content configurations.

@21:24 Switch back to group style - see the individual cells more clearly., and see how they respond to
different dynamic type sizes.  By default, everything responds dynamically to these changes. As increase the text
size, the entire layout adjusts to accommodate them.  and if go to largest text size, see that the cell layouts
use a special mode where the text wraps around the image to maximize the space for the content.

content configurations are built from the ground up for supporting dynamic layouts likes this.

@22:09 - under the hood.  Designed to be used with self-sizing cells, where height can be flexible depending
on the the exact configuration and environment. this is important to ensure that your app looks great when
running on device size at different dynamic type sizes and different amounts and types of content.

content configurations give you control over the the layout margins (in blue @22:39) and layout properties
in orange.  Together with the actual content , determine the intrinsic height and affect how the cell
self-sizes. 

Instead of trying to enforce a fixed height, you should use these properties on the content 
configuration to influence the layout and let the height adjust dynamically.

@23:03 One more layout concept you should know about.

@23:30 Three different cells each using a content configuration with an image and some text.
Right now, everything looks pretty good.  But say want to use different images in these cells,
(second cell is wider).  The images aren't exactly the same size. Slightly different widths.  So
the images and text aren't aligned across cells anymore.  The images are leading-aligned, and the text
is positioned with the same amount of padding from the trailing edge of each image.

@23:45 To get the right alignment across these cells, need to specify a _reserved layout size_ for
each image. @23:55 If we set the same reserved layout width for the image on each content configuration,
what that does is horizontally center the image inside that reserved amount of space.  The distance
between the two red dotted lines is the reserved layout width for each image.  The reserved layout size
does not affect the actual size of the image. If the image is laaaarger than the reserved size, it will
be allowed to extend outside of that area.

using the reserved reserved layout size for the image also correctly aligns the text b/c the text is positioned
relative to the same reserved layout area for the image in each cell.

if using symbol images, UIKit applies a standard reserved layout size automatically which you can request
manually for non-symbol images if needed.

That's what you need to know about list content configuration layout.

@24:47 Let's go over some important details to keep in mind.

If you have existing code that your'e updating and migrating over, keep in mind that configurations
are mutually exclusive with existing properties, like backgroundColor or backgroundView.
Setting a bg config always resets the background color and background view properties to nil.

The same thing happens the other thing around.  make sure you don't mix background configuration with
other code still setting these other background properties on the same cell.

Specifically for those of you using UITableViewCell, content configurations supersede the built-in
subviews of cells, headers and footers (like the imageView/textLabel/detailTextLabel)

These legacy content properties will be deprecated in the future. encourage you to adopt content configurations
to take advantage of their more powerful features and enhanced customizability.

@26:00 The background configuration and list content content configuration types are incredibly powerful, but
there are still going to be times when you need to do something more custom.

With configurations, you have more options than ever before.

In addition to the list content configuration, we're also giving you access to the associated list content
view, which implements all of the rendering.  You just create or update this view using the configuration

@26:25

```
var content: UIListContentConfiguration = ...
let contentView = UIListContentView(configuration: content)
```

and then can add it as a subview right alongside your own custom view. This lets you take advantage of all
the content configuration features, and combine the list content view with your own custom views next
to it, like an extra image view, or a label

Because the list content view is just a regular UIView, you can actually use it by itself anywhere, even
outside of  a collection or tableview, like in a plan UIStackView.

What about cases when aren't building a list at all? or want to do something completely custom?

@27:10 configurations have you covered!  Even if building a completely custom view hierarchy inside your
cells, you can still use the system configurations to help.  b/c configurations are so lightweight, you can
use them as a source of default values for things fonts, colors, and margins, that you copy over to your
custom views (huh. COOL), even if you never apply the configuration directly itself.

For more advanced uses, can crate a completely custom content configuration type with a paired content
view class that renders it, and use your custom configuration with any cell the same way that you
would use a list content configuration.

With a custom configuration, you can take advantage of all the features that we've talked about, including
allowing your custom configuration to automatically update itself for new states.

No matter how complex or custom your cells are, you'll be able to take advantage of the power of 
configurations.

@28:20 We've covered all the essentials of modern cell configuration.  _(sales pitch elided)_


==================================================
# Developer's guide to Cell Content Configuration

Matt Neuberg, https://www.biteinteractive.com/cell-content-configuration-in-ios-14/
  (go read that and toss him some views. These are just my notes.)

Remember this kind of stuff?

```
func cellForRowAtIndexPath {
    let cell = tableView.dequeReusableCell
    let label = ... // like get from the cell
    label.text = "Snorgle"
    return cell
```

This the data source, it should have no business knowing the cell contains a label.
It (the _data_ source) should just supply the cell with _data_.  How the cell renders
that data is no business of the data source.

So, the standard rejoinder is to make your own UITableViewCell subclass, and add a `configure` method.
That breaks the dependency between the data source and the cell

```
....
cell.configure(text: "Snorgle")
```

Cells should be self-configuring.  duh.  Apple catches up with iOS 14
"As usual with Apple, this architecture is twice as elaborate and complicated as it needs to be"
_(#lolz)_


- UIContentConfiguration - object that produces a content view
- UIContentView - view with a settable property that is a content configuration

(a bit circular) They're protocols.  Can delcare the content configuration object as struct

This is the rock-bottom pair of configuration and view:

```
class BlahContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.initframe: .zero)
    }

    required init?( ... get bent )
}

struct BlahConfiguration: UIContentConfiguration {
    func makeContentView() -> UIVuew & UIContentView {
        return BlahContentView(self)
    }

    func updated(for state: UIConfigurationState) -> MyContentConfiguration {
        return self
    }
}
```

The idea is 
  * a content view contains and configures views
  * a content configuration communicates data to the content view

So, make it do stuff.  The content view is a single label, centered.
So the minimum going to need is that text

```
struct SnorgleConfiguration: UIContentConfiguration {
    var text = ""

    func makeContentView() -> UIVuew & UIContentView {
        return SnorgleContentView(self)
    }

    func updated(for state: UIConfigurationState) -> MyContentConfiguration {
        return self
    }
}      
```

by giving the configuration a text property.

The content view is the workhorse:
  - separate the configuration of the view from the application of the data that comes in from the config object
  - in the content view initializer, configure the content view,
    - give it subviews as needed
  - at the end of the init, and in a setter observer on the `configuration` property, apply the data
    - that way the timing doesn't matter - get it at init time, or have it set when needed

```
class SnorgleContentView UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure(configuration: configuration)
        }
    }

    let label = UILabel()

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        addSubview(label)
        // configure lavel, set constraints
        configure(configuration: configuration)
    }

    required init?(coder) // blahblah

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? SnorgleContentConfiguration else { return }
        label.text = configuration.text
    }
}
```

_(that's a fair amount of ceremony)_

OBTW, all of this is totally independent of tableviews etc.

What is a tableview cell?  it's a cell with a _content configuration property_.  When the property
is set, the cell effectively rips out its own contentView and replaces it with the content
view that came from the configuration object.  _(ooooh, does this mean we don't have to subclass
the cells any more?)_

So here's a datasource method:

```
override func tableView(cellForRowAt) {
    let cell = tableView.dequeueueue
    var config = SnorgleConfiguration()
    config.text = "blah"
    cell.contentConfiguration = config
    return cell
}
```

so yay, the cell is self-configuring.

The tableview cell has a contentConfiguration property.

Built-in Configs

If we want standard tableview appearance, we don't have to build our own stuff (yay)

UIListContentConfiguration, and a tableview cell will automatically dispense one when we ask for
its defaultContentConfiguration.

Now for even simpler

```
override func tableVieW(cellForRowAt) {
    let cell = dequeue
    var config = cell.defaultContentConfiguration()
    config.text = "Hello, Sailor" // _nothing happpens here_
    cell.contentConfiguration = config
    return cell
}
```

that changes the look though (text is left aligned).  To get it back to the original

```
var config = cell.defaultContentConfiguration()
config.text = "Blah"
config.textProperties.alignment = .center
cell.contentConfiguration = config
```

Apple is signaling the deprecation of things like tetxLabel, detailTextlabel, and imageView.
The config objects have text, secondaryText, thirdBreakfast, and image properties (also
attributedText and secondaryAttributedText and thirdAttributedBreakfast)

Three big things didn't cover

* States - e.g. highlighted / selected, along with other states like UI (light/dork) that might
  change, size class, etc. 
  `func updated(for state: UIConfigurationState) -> BlahContentConfiguration` is where you'd adapt to
  changes there

* Backgrounds - there's a `backgroundConfiguration` property, so can do for the background what we did
  for the content.  "whole other kettle of fish, needs to be discussed in connection with states"

* collection views - UICVCell also has a contentConfiguration and backgroundConfiguration, so :alot:
  of the stuff applies.  In general a collection view cell does not dispense a default configuration.
  Can also use the UIListContentConfiguration.  Also a UICollectionViewListCell that does dispense
  a UIListContentConfiguration as its defaultContentConfiguration.

----------

https://www.biteinteractive.com/user-interactive-cell-configurations-in-ios-14/

_(so, my brain was going to the "ok that's great for static cells, but how do you hook
up controls?  and then there's a link to this!)_

So, what about _user-interactive_ cell content?

Say the cell has a UISwitch.  The switch rflects a piece of the tableview's model data.
Presumably you have a model object for each row of the table, and it contains a bool.
if it's true, the switch is on.  if false, switch is off. _(that part is easy)_

what happens when the user toggles the switch?  Some ideas are using target/action

```
let toggle = // the UISwitch
toggle.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
```

Dude's favorite way:
* the switch is passed to the callback
* walk up the view hierarchy / responder chain until come to the cell
* ask the tableview what row the cell is
* now can update the model data


(this is kind of slick)

```
extension UIResponder {
    func next<T: UIResponder>(ofType: T.Type) -> T? {
        let r = self.next
        if let r = r as? T ?? r?.next(ofType: T.self) {
            return r
        } else {
            return nil
        }
    }
}
```


and used

```
@objc func switchChanged(_ senderprize_: UISwitch) {
    if let cell = sender.next(ofType: UITableViewCell.self) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            // update the model at the indexpath
        }
    }
}
```

But now if you have a cell content configuration object, the direct connection 
between the uiswitch and thecell and the data source goes away.

So have three places to tweak:

* the content configuration object needs a property.  That's pretty much all configuration
  objects really have. So needs to be a property that allows us to establish a communications
  conduit between the switch in the cell and the tableview's data source

* In the configuration objects' content view, we need to _respond_ to that property to configure
  the actual UISwitch in the interface.  The content view is the view, so it's the thing
  that knows about the switch - target/action here

* the data source's cellForRowAt, need to set that property in such a way that
  we get called back so can updatre the data model when we are called back

Looking at two ways

Protocol and Delegate
The content configuration object has a delegate, and keeps a referne to it in
a property (say `delegate`)

The content view knows of a message that is allowed to end to that delegate.

so, example

```
protocol SwitchListener: AnyObject {
    func switchChangedTo(_: Bool, sender: UIView)
}
```

then content configuration will have 

```
weak var delegate: SwitchListener?
```

and then in the content view configuration

```
toggle.addAction(UIAction { action in
    if let sender = action.sender as? UISwitch {
        (configuratin as? Config)?.delegate?.switchChangedTo(sender.isOn, sender: sender)
    }, for: .valueChanged)
```

then the data source assigns confg.delegate = self

then all that remains is for the datasource (self) to conform to the protocol.
*that*'s the place that does a indexPath(for: cell)

```
extension ViewController: SwitchListener {
    func switchChangedTo(_ newValue: Bool, sender: UIView) {
        if let cell = sender.next(ofType: UITableViewCell.self) {
            if let ip = self.tableView.indexPath(for: cell) {
                self.list[ip.row] = newValue
            }
        }
    }
}         
```

"It works, but I don't like it." - a lot of work, and stuff scattered around in different places.
And there's two distinct signals - the UISwitch sends a signal to the action, which sends
a different signal to the delegate.

A Property that's a function (closure)

Rather than give the configuration object a reference to an object that implmement
a function, just give it a function

```
var isOnChanged: ((Bool, UIView) -> Void)?
```

content view configures the switch - calls the content configuration object
property's function

```
toggle.addAction(UIAction { action in
    if let sender = action.sender as? UISwitch {
        (configuration as? Config)?.isOnChanged?(sender.isOn, sender)
    }
}, for: .valueChanged)
```

and in the data source

```
config.isOnChanged = { [weak self] isOn, value in
    if let cell = v.next(ofType: UITAbleViewCell.self) {
        if let ip = self?.tableView.indexPath(for: cell) {
            self?.list[ip.row] = isOn
        }
    }
}
```

oh, and watch the [weak self] for memory leaks

_(so why not capture the index path here and avoid the groveling around the view hieraerchy?)_

==================================================

https://swiftsenpai.com/development/uicollectionview-list-custom-cell/

_(like above, these are just my notes.  If its useful go toss them a a view 

