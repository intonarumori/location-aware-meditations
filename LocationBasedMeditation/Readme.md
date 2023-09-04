# Location-Aware Meditations

- On the model side I've mostly focused on setting up the location monitoring, parsing and loading the data
- On the UI side I focused on getting close to the design and identifying any issues that are hard to achieve with SwiftUI


# Design Notes

- The design uses an unconvetional title for the list which has a custom gradient and it's not immediately clear how it would behave when the list scrolls, I would follow up on this aspect with the design team
- The design also uses a bar button that is larger than the standard navigation bar buttons, this makes it hard to use the build in SwiftUI mechanisms to transition from the large title to an appearing navigation bar as the button would not fit
- Due to these reasons I made the title scroll with the list for now, which is good enough as a prototype to aid further discussion with the design team

# Implementation Notes

- I built the skeleton of the feature, but would spend more time on finding edge cases around location tracking and network connectivity
- Tests need to be added by mocking the location and network services and verifying all edge-cases are covered


## Future Improvements

Some aspects of the code that could be improved:
- Network reachability handling
- Tweaking SwiftUI code to use less modifiers around styling the list
- Tests
