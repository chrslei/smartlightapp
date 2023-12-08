//
//  Smart_Light_AppApp.swift
//  Smart Light App
//
//  Created by Christopher Leibiger on 04.12.23.
//

import SwiftUI

@main
struct Smart_Light_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Lights(lights: [Light(name: "Decke", room: 1, brightness: 0),
                                                            Light(name: "Decke 2", room: 1, brightness: 0),
                                                            Light(name: "Stehlampe", room: 2, brightness: 0),
                                                            Light(name: "Tischlampe", room: 2, brightness: 0),
                                                            Light(name: "Wandleuchte", room: 3, brightness: 0),
                                                            Light(name: "Sideboard", room: 3, brightness: 0) ]))
        }
    }
}
