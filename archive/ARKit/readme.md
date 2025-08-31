# ARKit

Prep for Clash 2022.

Reading _Mastering ARKit_ by Jayven Nhan (Apress)

The first chapter is oddly cheerleadery.  Second chapter has a some
errors in it (like "The second action scales a node by a factor of 1.5
from its identity in the x, y, and x scale").  Ton of grammatical errors.
"In adjunction" instead of "in addition"

## Matrices

4x4 matrices kind of important.

Addition is piecewise

|1 2 3|   |6 5 4|   |7 7 7|
|4 5 6| + |3 2 1| = |7 7 7|

(kind of a weird digression about matrices being arrays of arrays, and
swift + operator concatenatin rather than doing matrix math)

For an |x y z| vector
  - z axis points towards viewer
  - y points to the sky
  - x points to the right

3D matrix is 4x4 - x,y,z and w
  - w is the fourth component of a rotation vector
  - useful for when you want to describe a quaternion rotation in a 3-D space

A transformation matrix with rotation is of the form
|cos -sin 0 0|
|sin  cos 0 0|
| 0   0   1 0|
| 0   0   0 1|

## Misc

Frameworks:
  - SpriteKit - anything 2D in the 3D space. (w/o scene kit, the shape will face the user)
  - SceneKit - high-level 3D rendering API
  - Metal - \m/
  - RealityKit - mentioned but not defined

Factors for performance and user-friendliness
  - handle the app's AR session life cycles
  - keep track of the tracking quality of the app
  - create appropriate UIs to bind them

life cycles
  - not available
    - "feature point deficiency to recognize the device's position in the world"
    - needs additiona feeding of "feature points"  (not defined)
  - limited with reason
    - app has gathered some feature points, but not enough to say map out a flat surface
    - maybe insufficient feature points - say when facing a blank wall or poor lighting
    - low-level of initialization state - needs to acucmulate more camera or motion data
    - excessive motion
    - session is interrupted and needs to "relocalize", like incoming facetime call
    - the app can maybe function with imperfect conditions. performance and accuracy of
      object placement and device position can "have plenty of room for imrpvement"
    - "at this state, plane detection is limited from adding or updating a plane anchor
      and hit-testing results" - all forward references :-( 
      - this condition is best met with more quality feature points for ARKit to make
        better sense of the world.
  - normal
    - workable feature points
    - app works with a reliable world map
  - based on ARCamera.TrackingState
  - providing users with the option to reset tracking can be vital

quality transtions
  - sometimes seen objects slide around or some odd interactions
  - ARKit's understanding of the environment changes
  - app session can get interrupt when fails to collect camera or motion-sensing data
    - e.g. phone call, toggling to another app, locking device, going to background
  - "interrupt reconciliaton" should be available to bring your user back to the normal
     tracking state. Otherwise users might have to kill and relaunch

Relocalization
  - world map not defined yet
  - once a session is interrupted, more likely the virtual content is no longer
    positioned relative to the session's running real-world environment
  - app should run session configurations once again
  - for relocalizaton, can sessionShouldAttemptRelocalization delegate method (delegate
    of what?)  If this is enabled, ARKit tries to mesh together with the real-world
    environment from the last session
  - user can be stuck in a relocalization state if they've moved to an entirely different
    environment.  again letting them reset is vital

Resuming after quit or relaunch
  - ARKit uses world maps to relocalize from a session interrupt
  - world maps persist as a means of aggregating spcae-mapping states and anchors of a
    world tracking AR session (anchors?)
  - still unclear what a world map is
  - "the beauty of world maps is that it can be saved as a file"
    - "opens a particular session to a new realm of possibilities (sigh) like world
      map persistance and multi-user experiences in AR"
  - world map saves anchors from an AR session.  (YAY DEFINITION, even though Anchor is still
    a forward reference)

World map persistence
  - save it when a checkpoint is reached?
  - save the virtual content for privacy discernment manually? (?)
  - automatically save before backgrounding?

For backgrounding, appDidEnterBackground..  Foregrond,ing, "set the session
configuration's initialWorldMap to the saved world"

Possible flow yp to a normal track state
  - run configuration with an initial world map
  - limited tracking state from initialization
  - limited tracking state from relocalization
  - normal tracking state

Stopped chapter 3 - Designing an AR experience
