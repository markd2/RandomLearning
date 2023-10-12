# RoomPlan

AR Room Planner goodies.  Maybe get a cocoaheads preso out of it.

* marketing: https://developer.apple.com/augmented-reality/roomplan/
* docs: https://developer.apple.com/documentation/roomplan
* forums: https://developer.apple.com/forums/tags/room-plan/
* sample: https://developer.apple.com/documentation/roomplan/create_a_3d_model_of_an_interior_room_by_guiding_the_user_through_an_ar_experience
* ML research - https://machinelearning.apple.com/research/roomplan


## Marketing

https://developer.apple.com/augmented-reality/roomplan/

* ARKit powered
* Swift API
* uses camera and LiDAR on iPhong/Pad to create a 3D floor plan of a room.
    - including key characteristics such as dimensions and types of furniture.
* "Bring surroundings into your app"
* "engage customers / streamline workflows"
    - create a floor plan directly in your apps
         - like real-estate / ecomm, hospitality
    - interior design workflows
    - streamlien conceptual exploration and planning
* Real-time scanning with LiDAR
    - Light Detection And Ranging, is a remote sensing method that uses light in the form of a pulsed laser to measure ranges 
    - https://en.wikipedia.org/wiki/Lidar
    - "In 2022, Wheel of Fortune started using lidar technology to
      track when Vanna White moves her hand over the puzzle board to
      reveal letters."
      - YAY TECHNOLOGY
* Parametric representation
    - outputs in USD or USDZ file formats
       - include dimensions of each component recognizsed in the room
           - walls, cabinets, types of furniture
       - dimensions and placement of each component can be further
         adjust when exported into USDZ-compatible tools

## API

https://developer.apple.com/documentation/roomplan

- Use roomplan to creatae  3D model of an interior room.
- uses a device's sensors, trained, ML models, and RK to capture
  physical surroundings of an interior room.
- to being a capture, the app presents a RoomCaptureView
    - provides your app with a view that manages the scan process
      - end to end
    - camera feed
    - real time overlays on top of physical structures to show progress
    - user instructions on positioning / moving the device
- When the app determines that the current scan is complete, it 
  displays a dollhouse-version for the user to approve
- can also display custom graphics during the processing
  - using a RoomCaptureSession object directly

- iOS 17 introduces an initializer for the RoomCaptureView allowing
  us to use our own ARSession
    - can transitioning into a room-scanning session 
    - can use it across multiple room-capture sessions
      - different rooms in the same vicinity
      - can merge multiple capturedRoom opbjects into a single
        captured structure
      - more info(e) at CapturedStructure

https://www.it-jim.com/blog/apple-roomplan-api/

https://medium.com/simform-engineering/building-a-room-scanning-app-with-the-roomplan-api-in-ios-a5e9f66cfaaf
