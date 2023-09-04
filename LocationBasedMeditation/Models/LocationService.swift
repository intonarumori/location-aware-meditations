//  Created by Daniel Langh

import Foundation
import CoreLocation
import Dependencies
import Combine
import AsyncLocationKit

extension AsyncLocationManager: DependencyKey {
    public static var liveValue = AsyncLocationManager()
    public static var previewValue = AsyncLocationManager()
    public static var testValue = AsyncLocationManager()
}

extension DependencyValues {
    var locationService: AsyncLocationManager {
        get { self[AsyncLocationManager.self] }
        set { self[AsyncLocationManager.self] = newValue }
    }
}
