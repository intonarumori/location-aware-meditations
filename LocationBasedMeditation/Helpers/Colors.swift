//  Created by Daniel Langh

import SwiftUI

struct AppColors {
    static let background = Color(hex: 0xF1F1F1)
    static let footerText = Color(hex: 0xAAAAAA)
    static let navigationBarButton = Color(hex: 0x8B8B8B)
    static let headerGradient = [Color(hex: 0xCCADC1), Color(hex: 0xA6D6E0)]
    static let itemTitle = Color(hex: 0x727272)
    static let itemSubtitle = Color(hex: 0xA0A0A0)
    static let itemAccessory = Color(hex: 0x6E6E6E)
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
