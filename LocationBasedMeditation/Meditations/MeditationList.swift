//  Created by Daniel Langh

import SwiftUI
import CoreLocation
import ComposableArchitecture

struct MeditationList: View {
    
    var store: StoreOf<MeditationsFeature>
    
    var body: some View {
        
        let _ = Self._printChanges()
        List {
            Section {
                MeditationListHeader(store: store)
                    .listRowSeparator(.hidden)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    .listRowBackground(Rectangle().fill(Color.clear))
            }
            WithViewStore(store, observe: { $0 }) { viewStore in

                if viewStore.loadingState == .loading {
                    Section {
                        HStack(alignment: .center) {
                            ProgressView()
                                .controlSize(.regular).id(UUID())
                        }
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Rectangle().fill(Color.clear))
                    }
                }

                ForEach(viewStore.meditations) { item in
                    Section {
                        MeditationListItem(title: item.title, subtitle: item.subtitle, duration: item.duration)
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .background(.clear)
                                    .padding(20)
                            ).id(item.id)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .background(AppColors.background)
        .alert(store: store.scope(state: \.$locationSettingsAlert, action: { .locationSettingsAlert($0) }))
        .onAppear(perform: {
            store.send(.appeared)
        })
        .onDisappear(perform: {
            store.send(.disappeared)
        })
    }
}

struct MeditationListView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationList(store: Store(initialState: MeditationsFeature.State(meditations: [])) {
            MeditationsFeature()
        })
    }
}
