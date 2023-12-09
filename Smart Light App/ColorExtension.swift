import SwiftUI

extension Color {
    static let customWohnzimmer = Color(hex: "#4176C2")
    static let customFavorites = Color(hex: "#FFE040")
    static let customYellow = Color(hex: "FFDB00")
    static let customTurquoise = Color(hex: "82d1d0")
    static let customLightGreen = Color(hex: "82d193")
    static let customLimeGreen = Color(hex: "8FB991")
    static let customBad = Color(hex: "#96AE98")
    static let customLavender = Color(hex: "a382d1")
    static let customEsszimmer = Color(hex: "#B23943")
    static let customLighGray = Color(hex:"DEDEDE")
    static let customLightestGray = Color(hex:"F2F9F7")
    static let customBlack = Color(hex:"#3A3937")
    static let customScene = Color(hex:"b3b6b9")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0xff00) >> 8) / 255.0
        let b = Double(rgbValue & 0xff) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

struct ColorExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Lights(lights: [Light(name: "Decke", room: 1, brightness: 0),
                                               Light(name: "Decke 2", room: 1, brightness: 0),
                                               Light(name: "Stehlampe", room: 2, brightness: 0),
                                               Light(name: "Tischlampe", room: 2, brightness: 0),
                                               Light(name: "Wandleuchte", room: 3, brightness: 0),
                                               Light(name: "Sideboard", room: 3, brightness: 0) ]))
    }
}

