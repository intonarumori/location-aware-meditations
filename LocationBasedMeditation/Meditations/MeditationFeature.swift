//  Created by Daniel Langh

import SwiftUI
import ComposableArchitecture
import CoreLocation

struct MeditationsFeature: Reducer {
    
    enum LoadingState {
        case empty
        case loading
        case loaded
    }
    
    struct State: Equatable {
        var meditations: [Meditation]
        var coordinate: CLLocationCoordinate2D?
        var loadingState: LoadingState = .empty
        @PresentationState var locationSettingsAlert: AlertState<Action.LocationSettingsAlert>?
    }
    
    enum Action {
        case appeared
        case disappeared
        case locationPressed
        
        case locationStatusChanged(CLAuthorizationStatus)
        case locationChanged(CLLocationCoordinate2D?)
        case locationErrorReceived(Error)
        
        case locationSettingsAlert(PresentationAction<LocationSettingsAlert>)
        case meditationsResponse(TaskResult<[Meditation]>)
        
        enum LocationSettingsAlert: Equatable {
            case goToSettings
        }
    }
    
    @Dependency(\.locationService) var locationService
    @Dependency(\.meditationService) var meditationService
    
    private enum LocationMonitoringCancelID { case id }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .appeared:
                fallthrough
            case .locationStatusChanged:
                let status = locationService.getAuthorizationStatus()
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    return startMonitoringLocation()
                } else {
                    return loadDataWithLocation(state: &state, coordinate: nil)
                }
                
            case .disappeared:
                return stopMonitoringLocation()
                
            case .locationPressed:
                let status = locationService.getAuthorizationStatus()
                switch status {
                case .notDetermined:
                    return requestLocationAuthorization()
                case .denied, .restricted:
                    addLocationSettingsAlert(&state)
                    return .none
                default:
                    return .none
                }

            case .locationChanged(let coordinate):
                state.coordinate = coordinate
                return loadDataWithLocation(state: &state, coordinate: coordinate)
                
            case .locationErrorReceived:
                state.coordinate = nil
                state.loadingState = .loading
                return loadDataWithLocation(state: &state, coordinate: nil)

            case .meditationsResponse(let result):
                state.loadingState = .loaded
                switch result {
                case .success(let meditations):
                    state.meditations = meditations
                case .failure:
                    // TODO: signal error to the user
                    break
                }
                return .none
                
            case .locationSettingsAlert(.presented(.goToSettings)):
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                return .none
                
            case .locationSettingsAlert(.dismiss):
                state.locationSettingsAlert = nil
                return .none
            }
        }
    }
    
    private func startMonitoringLocation() -> Effect<Action> {
        return .run { [locationService] send in
            for await locationUpdateEvent in await locationService.startMonitoringSignificantLocationChanges() {
                switch locationUpdateEvent {
                case .didUpdateLocations(let locations):
                    await send(.locationChanged(locations.first?.coordinate))
                case .didFailWith(let error):
                    await send(.locationErrorReceived(error))
                case .didPaused, .didResume:
                    break
                }
            }
        }
        .cancellable(id: LocationMonitoringCancelID.id)
    }
    
    private func stopMonitoringLocation() -> Effect<Action> {
        locationService.stopMonitoringSignificantLocationChanges()
        return .cancel(id: LocationMonitoringCancelID.id)
    }
    
    private func loadDataWithLocation(state: inout State, coordinate: CLLocationCoordinate2D?) -> Effect<Action> {
        state.loadingState = .loading
        return .run { [coordinate, meditationService] send in
            let meditations = await meditationService.getMeditations(location: coordinate)
            await send(.meditationsResponse(TaskResult.success(meditations)))
        }
        .animation(.easeIn)
    }
    
    
    private func requestLocationAuthorization() -> Effect<Action> {
        return .run { [locationService] send in
            let status = await locationService.requestPermission(with: .whenInUsage)
            await send(.locationStatusChanged(status))
        }
    }

    // MARK: Alert handling

    private func addLocationSettingsAlert(_ state: inout State) {
        state.locationSettingsAlert = AlertState(title: {
            TextState("Turn on location services")
        }, actions: {
            ButtonState(role: .none) {
                TextState("Cancel")
            }
            ButtonState(role: .none, action: .goToSettings) {
                TextState("Open Settings")
            }
        }, message: {
            TextState("Open Settings, tap Location and select 'While using the app'")
        })
    }
}
