//  Created by Daniel Langh

import Foundation
import CoreLocation
import ComposableArchitecture
import AsyncLocationKit

extension DependencyValues {
    var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}

struct LocationClient {
    var requestAuthorization: @Sendable () async -> CLAuthorizationStatus
    var startTask: @Sendable () async -> AsyncThrowingStream<CLLocation, Error>
    var finishTask: @Sendable () async -> Void

    enum Failure: Error, Equatable {
        case taskError
    }
}

// MARK: Live Client

extension LocationClient: DependencyKey {
    static var liveValue: Self {
        let manager = AsyncLocationManager()
        return Self(
            requestAuthorization: {
                return await manager.requestPermission(with: .whenInUsage)
            },
            startTask: {
                let stream = await manager.startMonitoringSignificantLocationChanges()
                
                return stream.map { event in
                    switch event {
                    case .didUpdateLocations(let locations):
                        return locations.first!
                    default:
                        throw Failure.taskError
                    }
                }.eraseToThrowingStream()
            },
            finishTask: {
                return manager.stopMonitoringSignificantLocationChanges()
            }
        )
    }
}
