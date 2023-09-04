//  Created by Daniel Langh

import SwiftUI

struct MeditationListItem: View {
    let title: String
    let subtitle: String
    let duration: String
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Image("Circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240, height: 240)
                .padding(.trailing, -80)
                .layoutPriority(-1)
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(title)
                        .font(.title2.weight(.medium))
                        .foregroundColor(AppColors.itemTitle)
                    Text(subtitle)
                        .font(.headline)
                        .foregroundColor(AppColors.itemSubtitle)
                }
                Spacer()
                Text(duration)
                    .font(.title2.weight(.medium))
                    .foregroundColor(AppColors.itemAccessory)
            }
            .padding(EdgeInsets(top: 23, leading: 15, bottom: 29, trailing: 15))
        }
        .background(Color(white: 0.95))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .background(Color.clear)
        .shadow(color: Color(hex: 0xDDDDDD), radius: 10)
    }
}

struct MeditationListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationListItem(title: "Meditation name", subtitle: "Subtitle", duration: "5 min")
    }
}
