# Apple Dynamic Island

* on iPhongs 14 pro, an all 15s.
* ActivityKit handles the display
  - https://developer.apple.com/documentation/activitykit
* Displaying live data using live activities Lively (x)
  - https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities
* https://developer.apple.com/documentation/widgetkit/dynamicisland
  - dynamic island wedgie swiftui view
* HIG (x)
  - https://developer.apple.com/design/human-interface-guidelines/live-activities
* WWDC
  - https://developer.apple.com/videos/play/wwdc2023/10184 - Meet Activity kit
  - https://developer.apple.com/videos/play/wwdc2023/10194 - design dynamic live activities
* Updating live activities with ActivityKit push notification
s
  - https://developer.apple.com/documentation/activitykit/updating-live-activities-with-activitykit-push-notifications
* Accessibility - https://developer.apple.com/documentation/activitykit/adding-accessible-descriptions-to-widgets-and-live-activities
* Live Activities with push notifications - https://developer.apple.com/documentation/activitykit/updating-live-activities-with-activitykit-push-notifications
* ObToot: https://www.answertopia.com/swiftui/a-swiftui-live-activity-tutorial/
* Adding interactivity - https://developer.apple.com/documentation/WidgetKit/Adding-interactivity-to-widgets-and-Live-Activities
* animating - https://developer.apple.com/documentation/WidgetKit/Animating-data-updates-in-widgets-and-live-activities
* snapple code: https://developer.apple.com/documentation/widgetkit/emoji_rangers_supporting_live_activities_interactivity_and_animations
  - it's kind of huge
* unrelated, but relavent to my intersts for backgroudn timers
  - "You need to schedule a notification in future"
* caveman debugging really broken in xcode 15.
  - maybe https://lapcatsoftware.com/articles/2023/10/5.html

### Displaying live data with live activities

https://developer.apple.com/design/human-interface-guidelines/always-on

Live acativities show your app's most current data on the phong or pad
lock screen, and on the DIsland.

To offer live activities, add code to your EXISTING WIDGET EXTENSION or
create a new wedgie extension.

Live activities use widgetkit functionality and swiftUI for their user
interface.

ActivityKit's role is to handle the life cycle of each live activity.
Use its api to request, update, and end a live activity and to receive 
activity kit poosh notifications.

(enumerates the different forms)
  - to add support for live activities, you must support *all* presentations

Constraints
  - can be active up to 8 hours unless app or hooman ends it
    - removed from DIsland, but it remains on the lock screen
      - until removal, or 4 hours
    - so a max of 12 hoursx
  - the systemr equires image assets to use a resolution smaller or equal
    to the size of the presentation for a device
    - if it's bigger, the system might fail to start the live activity
    - e.g. the minimal shouldn't exceed 45x36.67 points
  - each live activity runs in its own sandbox
    - cannot access the network or receive location updates
      - unlike a widget
    - to update the dynamic data of an active live activity, use
      ActivityKit in your app or allow your live activities to receive
      ActivityKit Push Notifications 
  - the updated dynamic data for both ActivityKit updates and poosh 
    notifications can't exceed 4kb in size

Adding Support

- "although live activities leverage widgetkit's functionality, they
  aren't widgets"
  - in contrast to the timeline mechanism to update the widget's UI,
    update the LA via activity kit or with AKpoosh
  - you can create a widget extension to adopt live activities without
    offering a widget
    - consider offering both to allow peeps to add glanceable info nd
      a personal touch to their device

1. Create a widget extension.  Be sure to selected "include live activity"
   - c.f. https://developer.apple.com/documentation/WidgetKit and https://developer.apple.com/documentation/WidgetKit/Creating-a-Widget-Extension
   - I have no idea what a "Configuration App Intent" is, so turning off for
     the playpen
   - get an _Activate "TattooExtension" scheme? -This scheme has been
     created for the "(null)" target. Choose Activate to use this
     scheme for building and debugging. Schemes can be chosen in the
     toolbar or Product menu._
     - that null target fills me with hope and confidence that everything
       will work Just Fine.
     - crossing fingers and activtating
   - nice touch, it has a working(?) set of widgets out of the template
2. add "Supports Live Activities = YES" to the plist (equivalent)
   - _also need to have "push notification" capability added on the app target_
     - https://developer.apple.com/forums/thread/712223
3. add code that defines an ActivityAttributes structure to describe the
   static and dynamic data of the live activity
   - https://developer.apple.com/documentation/activitykit/activityAttributes
   - presumably this is part of the widget target source.
   - _make this in something shared between the app and the wedgie_
4. Use the ActivityAttributes defined to create the ActivityConfiguration
   - https://developer.apple.com/documentation/WidgetKit/ActivityConfiguration
5. add code to configure/start/update/end your live activies
   - draw the rest of the fucking owl
   - not even links or a howdy-do.
6. Make your live activity interactive with button or toggle
   - https://developer.apple.com/documentation/WidgetKit/Adding-interactivity-to-widgets-and-Live-Activities
7. Add animutations to bring attention to content updates
   - https://developer.apple.com/documentation/WidgetKit/Animating-data-updates-in-widgets-and-live-activities

### Configure / Start / Update / End live activities

- an app can start several live activities, and a device can run LAs from
  several apps.
  - exact number depends on Factors
  - so handle errors gracefully when starting/updating/ending themx

* Starting
  - make sure it's available
    - use `areActivitiesEnabled`, which is part of ActivityAuthoriationInfo
  - make an activity content
    - the emoji rangers has it as shared code.
    - `#if canImport(ActivityKit)`
  - I love how the code in the "displaying live data with live activities"
    - like a "setup(withActivity: activity)" method and errorMessage property
  - Activity.request - requests and starts a live activity
    - the sample uses ".token" as the pushType parameter
    - more info at https://developer.apple.com/documentation/activitykit/updating-live-activities-with-activitykit-push-notifications
    - ".token" to configure a live activity that updates dynamic content
      by ActivityKit pooshes
    - it's also the _only_ option
  - you can only start a live activity while it's in the forgound
    - from the background, you can update and end it, like via Background Tasks
      - https://developer.apple.com/documentation/backgroundtasks
  - Using said code
    - The operation couldn’t be completed. (com.apple.ActivityKit.ActivityInput error 0.)
    - "resolved this by ensuring the application target had the push capability added"
  - not shown in the app (makes sense), so need to background 

* Updating
  - use the update function of the Activity object you got, giving it a new
    ContentState.
  - can have an AlertConfiguration - if not nil when calling the update
    - its existance means this is an alert and gets special treatment
  - The activity.update is an async method
    - so Task, or async coloring
  - staleDate: The date when the system considers the live activity to be
    out of date, so it'll change to .stale
  - relevanceScore: relative ordering of live activities from the app, in case
    there's multiple in-flight. (otherwise sorted by date, so what was
    presented first).  Also controls the order on the lock screen.
  - can do an update via APN
  - Animating
    - when definiting the UI, the system ignores any animationm modifiers
      - e.g. withAnimation(_:_:) / animation(_:value:)
    - The system performs some animation when the dynamic content
      of the live activity changes
    - text views animated content changes with blurred content transitions
    - if you add or remove views, they fade in and out
    - use these to configure the built-in transitions
      - opacity
      - move(edge:)
      - slide
      - push(from:)
      - and combinations
      - requests animations for "timer text" with numericText(countsDown:)
        - https://developer.apple.com/documentation/SwiftUI/ContentTransition/numericText(countsDown:)
        - as simple as
          `Text("T \(context.state.emoji)").contentTransition(.numericText())`


* Ending
  - can do via APN
  - there's also an `end` method, give it the final contentstate to display.
    (or nil)
  - also a dismissal policy
    - default - keeps around on the lock screen for four hours
      - state doesn't turn to dismissed until the system or user removes itx
    - immediate - get rid of it now
    - after(Date)

* Activity States
  - active
  - ended - is visible, but won't update its content)
  - dismissed - ended and is no longer visible b/c person/system removed it
  - stale - like user moves out of a network connection so the live activity
    doesn't get updates.  Specifying a stale date triggers this when it
    expires

### Activity Authorization Info

* https://developer.apple.com/documentation/activitykit/activityauthorizationinfo
* are you allowed to start Live Activities?
  - by default, your capp can start/update/end live activity if use
    activity kit.
  - a user can deactivate them in Settings
  - check with
    - (synchronous) areActivitieEnabled
    - (async sequence) activityEnablementUpdates
* are you allowed to update LA with frequent ActivityKit poosh notifications?
  - check with
    - (synchronous) frequentPushesEnabled
    - (async sequence) frequentPushEnblementUpdates
  - obtw need to add NSSUpportsFrequentLiveActivitiyUpdates(YES) in plist
  - though nowhere is "frequent" actually defined?
  - settable as a property in settings for the app, so user can turn on/off
    - though not seeing the "frequent push" setting on my phong


### HIG

https://developer.apple.com/design/human-interface-guidelines/live-activities

"A live activity displays up-to-date information from your app, allowing
 peeps to view the progress of events or tasks at a glance"

- shows lozenge with   (KC 7 ---- SF 6)
- then shows a windoid with scores, game time, sportsball stuff
- "lets keep track of tasks and event they care about, offering persistent
   locations for displaying information that updates frequently"
  - food deliverty the time remining
  - sportsball app with score

In additional to display a lie activity on the lock screen, devices that
support Live Activities and display app information in different ways, 
depending if the device has a dynamic item
  - on devices with dynamic islant, the system displays Live activities in
    a persistent location around the TrueDepth(tm) camera
  - lesser devices, the system can display aLive Activity update in a banner 
    that appears at the top of the screen.

Live activities appear in highy visible locations and extend your app's
reach to the lock screen, in the dynamic island, and as an overlay at the
top.

* Must support the following presentation typeS:
  - Compact
    - Ears on both sides of the notch
      - "leading" and "trailing" side
    - when there's only one live activity currently active
    - two views, but representing a single piece of info(e) from the app
    - tap the activity to open the app and get more details
  - Minimal
    - multiple Live Activities are active
    - system displays two of them i nthe DIsland.
    - one appears attached while other is detached
       - `(  ------)  ( )`
       - detacthed one can be circular or oval depending on size
     - tap to open the app and get more details
  - expanded
    - touching and holding a live activity in a compatc/minimal,
      displays the content in an expanded presentation
  - lock screen
    - on the lock screen, system uses local screen presentation to display
      a banner at the bottom of the screen.
    - should use layout similar to the expanded presentation
  - no DIsland
    - system uses the lock screen presentation as a banner that briefly
      overlyas the home screen or another app.
    - only happens when your Live Activity contains an alert configuration
  - StandBy - displays the live activity in the minimal detched appearance
    - landscape orientation, charging, angled to face the room.
    - tap to see the lock screen appearance, scaled to fill the screen.


* Beast Practices
  - offer a live activity for tasks and live events that have a defined
    beginning and end.
    - people use to track events with frequently updating data, or monitor the
      status of ongoign tasks
    - don't offer one for a task that exceeds 8 hours (call your doctor...)
      and always end the live activity immediately after the task complets or
      the event ends.
  - present only the most essential content
    - summary and key bits
  - use animations to bring attention to content updates
    - live activities use system and custom animations with a maximum
      duration of two seconds
    - the system doesn't perform animations on alway-son displays with
      reduced luminance
      - c.f. Displaying live data with Live Activities https://developer.apple.com/documentation/ActivityKit/displaying-live-data-with-live-activities
  - avoid displaying sensitive information in a live activity
    - can be seen by casuals
    - if it's sensitive, display an innocuous summary and let folks tap the
      Live Activity to get more info
  - avoid ads or promotions
  - support StandBy.
    - when a user taps the minimal presentation in StandBy, the system
      scales the lock screen appearnce by 2s to fill the screen.
    - make sure your assets look great in the scaled-up presentation

* Make Live Activities Interactive
  - make sure tapping the LA opens your app at the right location
    - talk users directly to details and actions related to the a ctivity
    - developer guidance on SwiftUI views that can deep link to specific
      screens, see https://developer.apple.com/documentation/SwiftUI/Link and
      widgetURL(_:)
  - allow users to interact with your app or respond to event or progress
    updates.
    - in iOS 17, the expanded appearance in the DIsland and LockScreen
      can include buttons or toggles
    - use them to respond to updated data
      - e.g. food app dasher show a button check in when they pick up an order

* Starting / updating / ending a live activity
  - give users control over the beginning/ending of the activity
    - provide buttons to stop or cancel a live activity in the linked view
      in the app
    - gives folks control over content on lock screen / DIsland
  - automatically start one when users expect it
    - like using the app to start a task (foooood) makes sense to
      automatically start one.
    - in settings users can turn off live activities for the app, so
      avoid surprising folks by starting one they don't expect
  - update only when new content is available, alerting only if it's
    essential to get their attention
    - alerting too often can be disruptive and annoying
  - consider removing a LA from the lock screen 15 minutes after it ends
    - in the DIsland, the system immediately removes it when it ends
    - by default the system shows a LA on the lock screen for up to 
      four hours (so they can see a final content update)
    - in many cases, the outcome is only relevant for a shorter time.
    - alternatively, tell the system to dismiss it at a specific time
      within that four-hour window

* Creating a consistent design
  - Ensure unified information and deisgn on the compact presentations
    in the DIsland
    - use colors to reinforce the relationship on the left/right side of 
      the notch
  - create consistent layouts between compact and expanded preos
    - the expanded preso is an enlarged version of the compact
  - consider consistent design in both lock screen and expanded presentation
  - adapt to different screen sizes and live activity presentations
    - guidance specifications - https://developer.apple.com/design/human-interface-guidelines/live-activities#Specifications
   - coordinate corner radius of content with the corner radius of the
     live activity
     - https://developer.apple.com/documentation/SwiftUI/ContainerRelativeShape
   - use standard margins for egibile content
     - expanded and lock screen - 20 points
     - for guidance, see https://developer.apple.com/documentation/SwiftUI/View/padding(_:_:)

* Choosing colors
  - consider carefully before using a cusstom background color and
    opacity on the lock screen
    - can't control on DIsland
  - choose colors that work well on apersonalized lock screen
    - apply custom tint colors and opacity sparangly
  - Support dork mode and always on.
    - https://developer.apple.com/design/human-interface-guidelines/always-on

## O'Reilly course
`
https://learning.oreilly.com/videos/mastering-widgetkit-in/9781801815819/9781801815819-video1_1/

Skipping ahead to Dynmaic island.

Activities to keep track of tasks and activities. Persistent location to
show informatioin that updates frequently.  e.g. pizza delivery app, the
latest step until it arrives. Or ride share shows status of a ride.

Can show on the lock screen.  And on some devices, LiveActivity can be shown
(on other devices, have a banner, showing a snapshot while viewing home screen),
but only interrupts if the app decides person should be interrupted.

Expand the pizza delivery widget into dynamic island.

Some basics. When displaying live activities in DI, show in one of 3
ways:
  - compact presentation, has a leading and trailing side
    - if only one live activity that is current
    - seperate views that surround the camera dealie
    - tapping opens app
  - minimal
    - circular minimal (detached)
      - showing two activities.
    - or attached leading side.
    - the OS picks one to be attached and detached.
    - two apps running same time and reporting activity
    - say pizza delivery, but you are driving.  Or your navigation app
      is running, and its LiveAcitivty is on the detached, and the 
      songs in on the minimal attached.
  - expanded
    - the full view
    - touch and hold in a compact or minimal, the system shows the
      content in an expanded presentation.

Tapping on either of them will open the appropriate app.

Have to support all three types.  Have seen where passed empty views
or icons, but we've provided all styles.

In addition to lock screen, DI supports live activities, that are
powered by Wedgie Kit.

(omitted the rest - not a fan of videos)


## WWDC Session

https://developer.apple.com/videos/play/wwdc2023/10184

Live Activity overtview - immersive glanceable way to keep status of task.
Discrete start and end, and can give update from background app updates or
remotely from poosh notifications

UA and MLB example

@1:07 - even more immersive on latest phones, with dynamic islant,
displays on activity on system when app si on backgdround.  When one
is active, rendered in its "compact" presentation.

Displays up to two live activities. One appaers attached to the 
TRUE DEPTH camera, and the other in a detacthed.  Both use their
"minimal" presentation

Any time, can live-press on the live activity to display its expanded
presentation, even more glanceable information.  Expanded, views can
deep link to different areas in app, providing a rich user experience.

Some newer experiecnes in 17.  IN addition to the lock screen and
dynamic island.  LA appear in stand-by .  And iPad also supports
Live activities.

Interactive Live Activities

- leverage widget enhnacements with widgetkit and wiftui
- add buttons or toggles to enahnce the user experience
- learn more to "BRING WIDGETS TO LIFE - wwdc 2023"

Overview

- rely on ActivityKit framework
   - app can request, update, and manage lifecycle
- layed out with SUI and widget kit
  - familiar to widgt home thing
- can be requested while in the foreground.
- only request due to discrete user action, following a user action,
  or beginning a task
 
User-moderated, similar to notification. Someone can dismiss or
turn them off all together.

API requires you to support all presentations
  - from lock screen to all 3 Dyamic island presentation
  - in standby, system scales lockscreen to the full screen

App can update remotely via poosh notification with Live Activity
push type.

c.f. UPDATE LIVE ACTIVITIES WITH PUSH NOTIFICATIONS wwdc

Lifecycle

example - choose to hear from the emoji ranger app, and go on an 
adventure. Hero will face challenges and fight with bosses.

The LA displays displays info about hero adventure - name and stats,
avatar, health, and description of what they experience

Four main steps

1. Request an activity
2. once started, update with latest content
3. observe activity state, like it being ended
4. end when completed

Request an activity

make sure your app is in the foreground, and configure your app so
you have an initial content and necessary request data.

Before I can request a LA from emoji rangers, need to define a set
of static and dynamic data for the activity

```
import ActivityKit

struct AdventureAttributes: ActivityAttributes {
    let hero: EmojiRanger // static

    struct ContentState: Codable & Hashable { // dynamic
        let currentHealthLevel: Double
        let eventDescription: Double
    }      
}
```

as my property changes, my LA UI will get updated.

Now that the dynamic and static data is ready, set up request.

```
let adventure = AdventureAttributes(hero: hero)

let initialState = AdventureAttributes.ContentState(
     currentHealthLevel: hero.healthLevel,
     eventDescription: "HUZZAH"
)

let content = ActivityContent(
    state: initialState, staleDate: nil,
    relevanceScore: 0.0
)

let activity = try Activity.request(
    attributes: adventure,
    content: content,
    pushType: nil
)
```

* staleDate: when data is considered out of date
* relevanceScore: order in which each live activity appears when
  severeal adventure activities are started.  If started another one,
  specify a different score.
* pushType - indicates if the live activity receives updates to its
  content via activity kit push notifications.  nil is receiving
  updates locally.

The live activity setting for the app needs to be enabled.

Update

Now how to update the adventure.  The dynamic attributes tell me how
I can update the activity

```
let heroName = activity.attributes.hero.name

// change health level and describe event
nlet contentState = AdventureAttributes.ContentState(
    currentHealthLevel: hero.healthLevel,
    eventDescription: "\(heroName) has taken a critical hit")

// since the hero is in bad state, send an alert.
// will display an alert on phone/pad/watch
// title and body only used on watch.
var alertConfig = AlertConfiguration(
    title: "\(heroname) has taken a critical hit",
    body: "open the app and use a potion to heal \(heroName)"),
    sound: .default)

activity.update(
    ActivityContent<AdventureAttributes.ContentState>(
        state: contentState,
        staleDate: nil),
        alertConfiguration: alertConfig
    )
)
```

Activity state changes can happen at any time. There are 4 possible stats
* started
* finished
* dismissed
* stale

observe via

```
func observeActivity(activity: Activity<AdventureAttributes>) {
    Task {
        for await activityState in activity.activityStateUpdates {
            if activityState == .dismissed {
                self.cleanUpDismissedActivity()
            }
        }
    }
}
```

when activity gets dismissed, make sure not keeping track of adventure
data, and update the UI in the app that I don't show an ongoing activity.

Can also check the state via activity state API to retreive it synchronously

```
let activityState = activity.activityState
if activityState == .dismissed {
    self.cleanUpDismissedActivity()
}
```

Ending

Create a final content.

```
let hero = activity.attributes.hero
let finalContent = AdventureAttributes.ContentState(
    currentHealthLevel: hero.healthLevel,
    eventDescription: "Adventure over!"
)

let dismissalPolicy: ActivityUIDismissalPolicy = .default

activity.end(
    ActivityContent(state: finalContent, staleDate: nil),
    dismissalPolicy; dismissalPolicy
)
```

policy ensures the information appears on the lockscreen for some
time after it ends, so someone can glance at the lock screen to
see how the adventure wrapped up.

@10:50 - UI

The widget extension has two widgets already.  Need to add the
live activity configuration to the bundle.

```
struct AdventureActivityConfiguration: Widget {
    var body: some WidgetConfiguration {
        ...
    }
}
```

needs to return a widget configuration in its body.

```
struct AdventureActivityConfiguration: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AdventureAttributes.self) { context in
            ...
        } dynamicIsland: { context in
            ...
        }
    }
}
```

the ActivityConfiguration describes the live activity.  Each closure
gets an activity view context, that has the static and dynamic
attributes, and activity ID

This is created based on the attribtue type passed in. Must match the
attribute the activity is requested with.


```
struct AdventureActivityConfiguration: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AdventureAttributes.self) { context in
            ...
        } dynamicIsland: { context in
            ...
        }
    }
}
```

Stopped at 11:52

