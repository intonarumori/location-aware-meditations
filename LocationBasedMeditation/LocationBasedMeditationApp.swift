//  Created by Daniel Langh

import SwiftUI
import ComposableArchitecture

@main
struct LocationBasedMeditationApp: App {
    var body: some Scene {
        WindowGroup {
            MeditationList(store: Store(initialState: MeditationsFeature.State(meditations: [])) {
                MeditationsFeature()._printChanges()
            })
        }
    }
}
