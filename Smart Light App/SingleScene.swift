//
//  Scene.swift
//  Smart Light App
//
//  Created by Christopher Leibiger on 06.12.23.
//

import Foundation
import SwiftUI

struct SingleScene {
    var name: String
    var number: Int
    var brightnesses : [CGFloat]
    var image: Image
    var isSelected: Bool = false 
    
    
    func activateScene(lights: Lights) {
        guard lights.lights.count == brightnesses.count else {
            print("Mismatch in counts")
            return
        }
        
        for (index, brightness) in brightnesses.enumerated() {
            lights.lights[index].setBrightness(to: brightness)
            print(lights.lights[index].brightness)
        }
    }
    
    mutating func select() {
        self.isSelected = !self.isSelected
    }
    
    func matchesCurrentLightSettings(lights: [Light]) -> Bool {
        guard lights.count == brightnesses.count else {
            return false
        }
        
        for (index, light) in lights.enumerated() {
            if light.brightness != brightnesses[index] {
                return false
            }
        }
        
        return true
    }
}
