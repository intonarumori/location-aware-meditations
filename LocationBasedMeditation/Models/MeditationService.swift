//  Created by Daniel Langh

import Foundation
import CoreLocation
import OSLog
import Dependencies

class MeditationService {
    
    func getMeditations(location: CLLocationCoordinate2D?) async -> [Meditation] {
        // Emulate some loading time
        sleep(1)
        do {
            let resource = location == nil ? "data.json" : "data_with_location.json"
            let data = try Data(contentsOf: Bundle.main.url(forResource: resource, withExtension: nil)!)
            let meditations = try JSONDecoder().decode([Meditation].self, from: data)
            return meditations
        } catch {
            os_log("Decoding error occured: \(error)")
            return []
        }
    }
}

extension MeditationService: DependencyKey {
    public static var liveValue = MeditationService()
    public static var previewValue = MeditationService()
    public static var testValue = MeditationService()
}

extension DependencyValues {
    var meditationService: MeditationService {
        get { self[MeditationService.self] }
        set { self[MeditationService.self] = newValue }
    }
}

