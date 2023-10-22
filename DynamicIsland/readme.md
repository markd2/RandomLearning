# Apple Dynamic Island

* on iPhongs 14 pro, an all 15s.
* ActivityKit handles the display
  - https://developer.apple.com/documentation/activitykit
* Displaying live data using live activities Lively
  - https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities
* https://developer.apple.com/documentation/widgetkit/dynamicisland
  - dynamic island wedgie
* HIG
  - https://developer.apple.com/design/human-interface-guidelines/live-activities
* WWDC
  - https://developer.apple.com/videos/play/wwdc2023/10184 - Meet Activity kit
  - https://developer.apple.com/videos/play/wwdc2023/10194 - design dynamic liev activities
* Updating live activities with ActivityKit push notification
s
  - https://developer.apple.com/documentation/activitykit/updating-live-activities-with-activitykit-push-notifications
* ObToot: https://www.answertopia.com/swiftui/a-swiftui-live-activity-tutorial/


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
2. If have an Info(e).plist, add Supports Live Activities to it = YES

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

