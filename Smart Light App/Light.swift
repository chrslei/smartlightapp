//
//  Light.swift
//  Smart Light App
//
//  Created by Christopher Leibiger on 06.12.23.
//

import Foundation

class Light: ObservableObject, Identifiable  {
    let id = UUID()
    var name: String
    var room: Int
    @Published var brightness: CGFloat
    
    init(name: String, room: Int, brightness: CGFloat) {
        self.name = name
        self.room = room
        self.brightness = brightness
    }
    
    func setBrightness(to newBrightness: CGFloat) {
        self.brightness = newBrightness
        self.objectWillChange.send()
    }
}

