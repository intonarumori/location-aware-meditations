//  Created by Daniel Langh

import SwiftUI
import ComposableArchitecture

struct MeditationListHeader: View {
    var store: StoreOf<MeditationsFeature>
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    WithViewStore(store, observe: { $0 }) { viewStore in
                        Button {
                            viewStore.send(.locationPressed)
                        } label: {
                            Image(systemName: "location.circle")
                                .font(.largeTitle.weight(.ultraLight))
                                .imageScale(.large)
                                .foregroundColor(AppColors.navigationBarButton)
                        }
                    }
                }
            }
            HStack {
                Text("Meditations")
                    .font(.largeTitle.weight(.medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: AppColors.headerGradient,
                            startPoint: .leading, endPoint: .trailing
                        )
                    )

                Spacer()
            }
        }
    }
}

struct MeditationListHeader_Previews: PreviewProvider {
    static var previews: some View {
        MeditationListHeader(store: Store(initialState: MeditationsFeature.State(meditations: []), reducer: {
            MeditationsFeature()
        }))
    }
}
